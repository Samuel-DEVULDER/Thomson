#!/bin/perl
# conversion de fichier midi en format pour le
# player "buzzer" thomson.
#
# (c) Samuel Devulder Fev 2016.
#

# http://www.sonicspot.com/guide/midifiles.html
# http://www.jchr.be/linux/format-midi.htm

# no buffering
$| = 1;

# frequence de base
$glb_period = 125;
$glb_noire = 0b00100000;
	
# d�calage
$glb_pitch = undef;

# nombre de notes maxi dans un arp�ge
$glb_arpg_max = 4;

# utilisation du noise ?
$glb_noise = 0;

# skyline par instrument
$glb_skyline_per_inst = 0;

# volume constant
$glb_vol = undef;

# -loop <0|1|2> -track a,b,c file.mid
@files = ();
%glb_tracks = ();
$prev = "";
for $curr (@ARGV) {
	if(-e $curr) {push(@files, $curr);}
	if("-h" eq $curr) {&usage;}
	if("-p" eq $prev) {$glb_pitch = $curr;}
	if("-n" eq $prev) {$glb_arpg_max = $curr;}
	if("-i" eq $curr) {$glb_skyline_per_inst = 1;}
	if("-d" eq $curr) {$glb_noise = 1;}
	if("-x" eq $prev) {
		my($i, @t) = (0, split(/,/,$curr));
		foreach $i (split(/,/, $curr)) {$glb_tracks{$i} = -1;}
	}
	$prev = $curr; 
}

@trk = ();
$file = "";
for my $f (@files) {
	$file .= ",$f";
	my @t = &read_midi($f);
	@t = &norm_bpm(@t);
	@t = &norm_inst(@t);
	push(@trk, &convert($glb_arpg_max, 0.5, @t));
}
die "file=$file" unless $file;
$file=~s/^,//;

#print "\n\n";
#for $k (keys %stat) {$tats{$stat{$k}} = $k;}
#for $k (sort {$a<=>$b} keys %tats) {
#	print sprintf("%6d => %d\n", $tats{$k}, $k);
#}
#exit;

$nom = "";
for my $f (split(/,/, $file)) {
	$f="./$f";
	$f=~/.*[\/\\](.*)(\.[^\.]*)?/;
	$nom .= ", $1";
}
$nom=~s/^, //;
print "* $nom\n";
for my $t (@trk) {print $t,"\n";}

exit(0);

sub usage {
	print __FILE__, " [-h] [-p <pitch-offset>] [-n <MIP>] [-s] [-d] [-x <t1,t2,t3,...>] <file.mid>";
	exit(0);
}

sub convert {
	my($glb_arpg_max, $tol, @zik) = @_;

	print STDERR "Conversion...";
	
	my(@trk, $i);
	local($vol_max);
	my($vol_fcn) = sub {
		my($v) = @_;
		return 0x80 if $v>$vol_max/2;
		return 0x40 if $v>$vol_max/4;
		return 0x20 if $v>$vol_max/8;
		return 0x10 if $v>$vol_max/16;
		return 0x00;
	};
	my(%note); # notes th�oriquements jou�es
	my($curr, $inst, $lvol) = (0, -1, 0);  # derniere note jou�e
	my($time, $next, $chl, $key, $vol);      # dernier instant
	
	my($last_tempo) = 0;
	my(@bpm) = (sort {$a <=> $b} keys %glb_bpm);
	my(@txt) = (sort {$a <=> $b} keys %glb_txt);
	my(%bend);

	for($i=0; $i<=$#zik;) {
		($time, $chl, $key, $vol) = @{$zik[$i]};
		
		# nouveau texte?
		if($#txt>=0 && $txt[0]<=$time) {
			my $txt = "";
			do {$txt.=$glb_txt{shift(@txt)};} while($#txt>=0 && $txt[0]<=$time);
			
			my $cod = "";
			my $lin = " fcb \$83";
			while(length($txt)>0) {
				my $a = $txt;
				$a = substr($a,0,32) if length($a)>32; $txt = substr($txt,length($a));
				while(length($a)>0) {
					my $c = substr($a,0,1); $a=substr($a,1);
					if(ord($c)<32 || ord($c)>127 || $c eq "/") {
						$c = sprintf("\$%x", ord($c));
						if($lin=~ / fcc /) {
							$cod.="$lin/\n";
							$lin = " fcb $c";
						} elsif($lin =~ / fcb /) {
							$lin .= ",$c";
						}
					} else {
						if($lin =~ / fcc /) {
							$lin .= $c;
						} elsif($lin =~ / fcb /) {
							$cod.="$lin\n";
							$lin = " fcc /$c";
						}
					}
				}
			};
			$lin .= "/" if $lin =~ / fcc /;
			$cod .= "$lin\n fcb \$0\n";
			push(@trk, $cod);
		}
		
		# nouveau tempo?
		if($#bpm>=0 && $bpm[0]<=$time) {
			my $bpm = $glb_bpm{shift(@bpm)};
			my($tempo) = int(60000000/$glb_noire/$glb_period/$bpm);
			#print "$bpm=>$tempo\n";
			push(@trk, sprintf(" fcb \$80,\$%02x", $last_tempo = $tempo)) if $tempo!=$last_tempo;
		}
		
		
		# bend?
		if($chl<0) {
			$chl = -$chl-1;
			my $bend = ($key-0x2000)/(0x1000+0.0); # arrondi0x
			delete $bend{$chl} unless $bend;
			$bend{$chl} = $bend;
			do {
				($next, $chl, $key, $vol) = @{$zik[++$i]};
			} while($time==$next && $i<=$#zik);
		} else {			
			# calcule dans %note les notes jouees a l'instant $time
			do {
				my($k) = abs($key).",$chl";
				
				#print "$time $chl $key $vol\n";
				if($key>0) {
					my($v) = $note{$k} & 1023;
					$v = $vol if $vol>$v;
					$note{$k} &= ~1023;
					$note{$k} += $v + 1024;
				} else {$note{$k} -= 1024;}
				delete $note{$k} if $note{$k} < 1024;
				($next, $chl, $key, $vol) = @{$zik[++$i]};
			} while($next<$time+$glb_ticks_per_note/32 && $i<=$#zik);
		}
		
		my($delay) = &time2tick($next - $time);
				
		my(%imp) = &important_notes($tol, %note);
		
		# trier max->min
		my(@k) = (0,0,0,0, sort keys %imp);
		my(@v);
		while($#k>=4) {shift(@k);}
		for my $k (@k) {
			my $v = $imp{$k} & 1023;
			push(@v, $v);
			$vol_max = $v if $v>$vol_max;
		}
		
		# percussions non interruptives mais ayant la priorit� 
		my($nz, $nnz) = (0,0);
		my($min_z) = 1000;
		my(%bend_k);
		while(my ($k, $v_) = each %note) {
			my($v) = $v_ & 1023;
			my($z,$ch) = split(',', $k);
			$bend_k{$z} = $bend{$ch};
			
			next if $ch!=9;
			$min_z = $z if $z<$min_z;
 			$nz += $v*$v if $glb_noise;
			++$nnz if $glb_noise;
		}
		$nz = sqrt($nz/$nnz) if $nnz>0;
		my($nz_r) = 0.7**($min_z / 36);
		
		# print STDERR "$nz $vol_max\n";
		#$k[0] = $min_z if $nz>0;
	
		
		for my $k (@k) {$k = &period($k+$bend_k{$k});}
		for my $i (0..$#v) {$k[$i] = 0 unless ($v[$i] = $vol_fcn->($v[$i]));}
		#print STDERR join("|", @k), "\n";

		my($last_nz_vol, $last_nz_dur, $first) = (0,0,1);
		while($delay>0) {
			my $d = $nz>0? 1 : $delay>=255?255:$delay;
			my ($z,$zk) = ($vol_fcn->($nz), 123); # && !$first; $first=0;
			($z,$zk) = ($v[0], $k[0]) unless $z;

			my($cmd) = sprintf(" fcb \$%02x,\$%02x,\$%02x,\$%02x,\$%02x,\$%02x,\$%02x,\$%02x,\$%02x,\$%02x,\$%02x,\$%02x,\$%02x,\$%02x",
				($nz>0?0x81:0x82), $d,
				$v[3], $k[3]>>8, $k[3]&255,
				$v[2], $k[2]>>8, $k[2]&255,
				$v[1], $k[1]>>8, $k[1]&255,
				$z,      $zk>>8,   $zk&255);
			my($push) = 1;
			
			if(@trk) {
				my($c1) = $trk[$#trk];
				my($c2) = $cmd;
				$c1 =~ s/,\$(..)/,\$_/; my $v1 = eval("0x$1"); 
				$c2 =~ s/,\$(..)/,\$_/; my $v2 = eval("0x$1"); 
				if($c1 eq $c2 && ($v1+$v2)<=255) {
					my $t = sprintf("%02x", $v1+$v2);
					$c1 =~ s/_/$t/;
					$trk[$#trk] = $c1;
					$push = 0;
				}
			}
			
			push(@trk, $cmd) if $push;
			$delay -= $d;
			$nz = int($nz * $nz_r);
			#$nz = 0; # <== bruit tr�s court
		}
	}
	print STDERR "done\n";
	
	#print join("\n",@trk);
	
	return @trk;
}

# https://newt.phys.unsw.edu.au/jw/graphics/notes.GIF
sub freq {
	my($key) = @_;
	my($f) = $glb_freq{$key};
	$glb_freq{$key} = $f = int(440*(2**(($key-69.0)/12))) unless defined $f;
	return $f;
}

sub key {
	my($f) = @_;
	return int(69+12*log($f/440)/log(2));
}

sub period {
	my($key) = @_;
	return 0 unless $key;
	my($f) = &freq($key);
	#print "f=$f k=$key\n";
	# 1/250�s = 4000hz --> 32768
	# 1/500�s = 2000hz --> 16384
	#print "key=$key f=$f --> ", int(32768*$f*$glb_period/500000), "\n";
	
	return int(32768*$f*$glb_period/500000);
}

# calcule le spectre d'une note
sub spectrum {
        my($key, $vol) = @_;
        my(%vol, $m);

        my($f) = &freq($key);

        $vol{$key} += $vol; #&ampl($vol, $f);
        foreach $m (3, 5, 7, 9) {
                last if $f*$m>$glb_max_freq;
                $vol{&freq2note($f*$m)} += $vol/($m**5);
        }
        return %vol;
}

sub important_notes {
	my($tol, %note) = @_;
	my(%sp, %keys, $key, $vol);
	
	if(1) {
		my(%sp) = %note;
		while(my ($k, $v) = each %sp) {$note{$k} = $v & 1023;}
	}
	
	if($glb_noise) {
		my(%sp) = %note;
		while(my ($k, $v) = each %sp) {
			my($z,$i) = split(',', $k);
			delete $note{$k} if $i==9;
		}	
	}
		
	if($glb_skyline_per_inst) {
		# pour chaque channel, on ne garde que la note la
		# plus haute (skyline)
		while(($key, $vol) = each %note) {
			my($k,$i) = split(',', $key);
			$sp{$i} = $k if $k>$sp{$i};
		}
		while(my ($i, $k) = each %sp) {$keys{"$k,$i"} = $note{"$k,$i"};}
		%note = %keys; %keys = (); %sp = ();
	}
	
	# calcul du spectre: on prends le sup
	# autre possibilite: on somme les harmoniques
	my($p) = 2;
	while(($key, $vol) = each %note) {
		my($k,$i) = split(',', $key);
		$sp{$k} += $vol**$p;
		#$sp{$k} = $vol if $vol>$sp{$k};
		#$sp{$k} = 63 if $sp{$k}>63;
	}
	for $key (keys %sp) {
		$sp{$key} = int($sp{$key}**(1/$p));
		$sp{$key} = 63 if $sp{$key}>63;
	}
	%note = %sp; %sp = ();
	
	#	print join(' ', %note),"\n";

	while(($key, $vol) = each %note) {
		my(%z) = &spectrum($key, $vol);
		while(my($k, $v) = each %z) {$sp{$k} += $v;}
	}
	
	if(0) {
	for $key (keys %note) {
		my($f, $g) = &freq($key);
		for $g (2 .. 20) {my($t) = &freq2note($f/$g); delete $note{$t};}
	}
	}
	
	#for $q (keys %note) {print $q,"=>",$note{$q}," ";} print "\n";
	
	
	# on trie les notes par intensit�, et � intensit� identique
	# par frequence
	my(@k) = (sort {($sp{$a}<=>$sp{$b} or $a<=>$b)} keys %note);
	#for $q (@k) {print $q,"=>",$sp{$q}," ";} print "\n";
	
	while(scalar keys %keys<$glb_arpg_max && $#k>=0) {
		my($t) = pop(@k);
		$keys{$t} = defined $glb_vol?$glb_vol:$note{$t};
	}

	return %keys;
}

sub by_time {
	my($time1, $ch1, $note1, $vol1) = @$a;
	my($time2, $ch2, $note2, $vol2) = @$b;
	
	my($d) = $time1 <=> $time2;
	$d = $note1<=>$note2 unless $d;
	
	return $d;
}

sub print_trk {
	my(@t) = @_;
	my($n);
	
	&flush_line;
	for $n (@t) {&add_note($n);}
	&flush_line;
}

# tous les instruments doivent �tre entre C1(24) et C5(72)
sub norm_inst {
	my(@trk) = @_;

	my($fmax) = 1000000/(2*$glb_period);
	my($fmin) = $fmax/32768;
	
	my($nMIN, $nMAX) = (&key($fmin), &key($fmax));
	
	if(0 && !defined $glb_pitch) {
		my($n, $m, $NUM);
		
		for($n=0; $n<9*12; $n+=12) {
			my(%num);
			for $t (@trk) {
				my ($next, $chl, $key, $vol) = @{$t};
				next if $key<0 || ($glb_noise && $chl==9);
				$key += $n;
				$num{$chl} = 1 if $key<$nMIN || $key>$nMAX;
			}
			my($num) = scalar keys %num;
			if($n==0 || $num < $NUM) {$NUM = $num; $m = $n;}
		}
		for($n=0; ($n-=12)>-9*12;) {
			my(%num);
			for $t (@trk) {
				my ($next, $chl, $key, $vol) = @{$t};
				next if $key<0 || ($glb_noise && $chl==9);
				$key += $n;
				$num{$chl} = 1 if $key<$nMIN || $key>$nMAX;
			}
			my($num) = scalar keys %num;
			if($n==0 || $num <= $NUM) {$NUM = $num; $m = $n;}
		}
		print STDERR "Pitch-corr : $m (", $NUM, ")\n";
		if($m) {
			for $t (@trk) {
				my ($next, $chl, $key, $vol) = @{$t};
				next if ($glb_noise && $chl==9);
				$t->[2] = (abs($key)+$m)*($key<0?-1:1);
			}
		}
	}
	
	my(%min, %max, $t, $k);	
	for $t (@trk) {
		my ($next, $chl, $key, $vol) = @{$t};
		next if $key<0 || $chl<0 || ($glb_noise && $chl==9);
		$min{$chl} = $key if !defined($min{$chl}) || $min{$chl}>$key;
		$max{$chl} = $key if $max{$chl}<$key;
	}

	my(%shift);
	for $k (keys %min) {
		my($min, $max) = ($min{$k}, $max{$k});
		print STDERR sprintf("%2d =%3d -> %-2d : ", $k, $min{$k}, $max{$k});
		
		if($min>=$nMIN && $max<=$nMAX) {
			print STDERR "ok\n";
		}
		
		if($min<$nMIN) {
			my($t);
			for($t=12;$min+$t<$nMIN; $t+=12) {}
			if($max+$t>$nMAX) {print STDERR "ko\n"; next;}
			else              {$shift{$k} = $t; print STDERR "+$t\n";}
		}
		if($max>$nMAX) {
			my($t);
			for($t=12;$max-$t>$nMAX; $t+=12) {}
			if($min-$t<$nMIN) {print STDERR "ko\n"; next;}
			else              {$shift{$k} = -$t; print STDERR "-$t\n";}
		}
	}

	for $t (@trk) {
		my ($next, $chl, $key, $vol) = @{$t};
		next if ($glb_noise && $chl==9);
		my($sgn) = $key<0?-1:1;
		$t->[2] = abs($key);
		if($shift{$chl}) {
			$t->[2] += $shift{$chl};
		} else {
			while($t->[2]<$nMIN) {$t->[2] += 12;}
			while($t->[2]>$nMAX) {$t->[2] -= 12;}
		}
		$t->[2] *= $sgn;
	}
	
	return @trk;
}

# change les BPM 
sub norm_bpm {
	my(@trk) = @_;
	
	#int(60000000/$glb_noire/$glb_period/$bpm);
	my($MAX) = 60000000/$glb_noire/($glb_period*16);
	my($MIN) = 60000000/$glb_noire/($glb_period*256);
	
	my($t, $max, $min);
	$min = $MAX;
	foreach $t (values %glb_bpm) {
		$max = $t if $t>$max;
		$min = $t if $t<$min;
	}
	print STDERR "BPM=",$min,"...",$max;
	
	my($scale) = 1;
	
	if($min<$MIN) {
		$scale = int($MIN/$min);
		$scale = int($MAX/$max) if $scale<int($MAX/$max);
		$scale = $MIN/$min if $scale==1;
	} elsif($max>$MAX) {
		$scale = 1/int($max/$MAX);
		$scale = $MAX/$max if $scale==1;
	} elsif(0 && $max<$MAX) {
		$scale = int($MAX/$max);
		$scale = $MAX/$max if $scale==1;
	} 
	if($scale!=1) {
		my(%t);
		print STDERR " x",$scale,"...";
		#$glb_ticks_per_note = int($glb_ticks_per_note*$scale);
		for $t (keys %glb_bpm) {
			$t{int($t*$scale)} = int($glb_bpm{$t}*$scale);
		}
		%glb_bpm = %t;
		for $t (@trk) {
			$t->[0] = int($t->[0]*$scale);
		}		
		print STDERR " done\n";
		
	} else {
		print STDERR "unchanged\n";
	}
	return @trk;
}

# lit un fichier midi
# retourne
# $glb_ticks_per_note = nb de ticks midi pour une noire
# %glb_tempo = map temps-midi -> tempo
# @glb_tracks = pistes 
sub read_midi {
	my($name) = @_;
	
	print STDERR "File       : ", $name, "\n";

	# open file
	open(MIDI, $midi_file=$name) || die "$name: $!, stopped";
	binmode(MIDI);

	# verif signature en-tete
	($_=&read_str(4)) eq "MThd" || die "$name: bad header ($_), stopped";
	($_=&read_long) == 6 || die "$name: bad header length ($_), stopped";

	# lecture en-tete
	my($format) = &read_short;
	my($tracks) = &read_short;
	my($delta)  = &read_short;

	print STDERR "FormatType : ", $format, "\n";
	print STDERR "#Tracks    : ", $tracks, "\n";
	print STDERR "Noire      : ", $delta, " ticks\n";
	
	$glb_ticks_per_note = $delta;

	%glb_txt = ();
	%glb_bpm = ();
	$glb_bpm{0} = $glb_tempo = 120; # default value
	if(1) {
		my $f = "./$name";
		$f=~/.*[\/\\](.*)(\.[^\.]*)?/;
		$f = $1;
		$glb_txt{0} = #sprintf("\033\133\033\140\014%s\r\n\033\150\033\153", $f);
			sprintf("\014%s\r\n\n\033\150\033\153", $f);
	}
	my($no, @trk);
	for($no=1; $no<=$tracks; ++$no) {
		push(@trk, &read_track($name, $no));
	}
	close(MIDI);
	
	@trk = (sort by_time @trk);
	#s&dump_midi(@trk);

	return @trk;
}

# lit une piste
sub read_track {
	my($name, $no) = @_;
	my(@track);
	
	my($z);
	($z=&read_str(4)) eq "MTrk" || die "$name: Reading track $no: bad chunk ($z), stopped";
	my($size) = &read_long(1);

	my($time) = 0;
	my($meta_event, $event) = 0;
	do {
		$time += &read_vlv;
		my($timr) = &timeround($time);
		
		$_ = &read_byte;
		if($_>=0x80) {
			$event = $_;
		} else {
			seek(MIDI, -1, 1);
		}
				
		if(&between($event, 0x80, 0x8f)) {
			# note off
			my $ch   = $event & 0xf;
			my $note = &read_byte & 0x7f;
			my $vol  = &read_byte & 0x7f;
			if (!$glb_tracks{$ch+1}) {
				$note += $glb_pitch unless $glb_noise && $ch==9;
				push(@track, [$timr, $ch, -$note-1, $vol]);
			}
		}
		if(&between($event, 0x90, 0x9f)) {
			# note on
			my $ch   = $event & 0xf;
			my $note = &read_byte & 0x7f;
			my $vol  = &read_byte & 0x7f;
			if(!$glb_tracks{$ch+1}) {
				$note += $glb_pitch unless $glb_noise && $ch==9;
				push(@track, [$timr, $ch,  $note+1, $vol]) if $vol>0;
				push(@track, [$timr, $ch, -$note-1, $vol]) if $vol==0;
			}
		}
		if(&between($event, 0xb0, 0xbf)) {
			my($code) = &read_short;
			if($code == 0x7800 || $code== 0x7B00) {
				print STDERR "mute all \n";
				#die "mute all";
				# mute all notes
				my(%set);
				for my $t (@track) {
					my ($next, $chl, $key, $vol) = @{$t};
					undef $set{$chl.",".-$key} if $key<0;
					$set{"$chl,$key"} = 1      if $key>0;
				}
				for my $k (keys %set) {
					my($ch, $note) = split(/,/,$k);
					push(@track, [$timr, $ch, -$note-1, 0]);
				}
			}
		}
		die "aftertouch" if &between($event, 0xa0, 0xaf);
		#die "pitch-bend: ".sprintf("\$%x",&read_short) if &between($event, 0xe0, 0xef);
		if(&between($event, 0xe0, 0xef)) {
			my $chl = $event & 15;
			my $bend = &read_byte;
			$bend += &read_byte<<7;
			push(@track, [$timr, -$chl-1, $bend, 0]);
			#print STDERR sprintf("pitch-bend $chl=%x\n", $bend);
		}
		if(&between($event, 0xa0, 0xaf) || 
		   #&between($event, 0xe0, 0xef) ||
		   $event == 0xf2) {&read_short;}
		if(&between($event, 0xc0, 0xdf) || 
		   $event == 0xf1 ||
		   $event == 0xf2) {&read_byte;}
		if($event == 0xff) {
			$meta_event = &read_byte;
			my $size = &read_vlv;
			if($meta_event == 0x51) {
				# set tempo
				die "bad tempo ($size)" unless $size == 3;
				my $tempo = 0; # �S par noire
				while($size--) {$tempo = ($tempo<<8) + &read_byte;}
				$glb_tempo = $tempo;
				$glb_bpm{$timr} = int(60000000/$tempo);
			} elsif($meta_event == 0x05) {
				# text
				my($txt) = &read_str($size);
				$txt =~ y/����������������/ceeaeiouCEEAEIOU/;
				$txt =~ s/\012/\015/g;
				$txt =~ s/\015+/\015/g;
				
				my $p = $glb_txt_pos;
				for my $i (0..length($txt)) {
					my $c = ord(substr($txt,$i,1));
					if($c==015)   {$p=0;}
					elsif($c>=32) {++$p;}
				}
				
				if($p>39) {
					$txt = "\015\030$txt";
				} else {
					$txt = "\030$txt" if $glb_txt_last_cr;
				}
				$glb_txt_last_cr = ($txt =~ /\015$/);
				
				$glb_txt{$timr} .= $txt;
				for my $i (0..length($txt)) {
					my $c = ord(substr($txt,$i,1));
					if($c==015)   {$glb_txt_pos=0;}
					elsif($c>=32) {++$glb_txt_pos;}
				}
				#print STDERR "$glb_txt_pos $txt\n";
				
				$txt =~ s/\015$/\012/g;
				print STDERR $txt;
			} else {
				&read_str($size);
			}
		}
	} while($event != 0xff || $meta_event != 0x2f);
	return (@track);
}

# arrondi le temps en ticks thomson
sub timeround {
	my($t) = @_;
	my($div) = $glb_ticks_per_note/0b00100000;
	return int(int($t/$div+0.5)*$div);
}

# conversion temps midi en tick thomson
sub time2tick {
	my($t) = @_;
	return int(($t*0b00100000)/$glb_ticks_per_note+0.5);
}

# affiche une piste midi � l'�cran
sub dump_midi {
	my($t, $tm);
	for $t (@_) {
		my($time,$trk,$note,$vol) = @$t;
		print "(",$time-$tm,")\n";
		print sprintf("%-6d %2d %3d *%-3d", $time, $trk, $note, $vol);
		$tm = $time;
	}
	print "\n";
}

# compare les index temporels des pistes
sub cmp_trk {
	return $a->[0] <=> $b->[0];
}

# test si un valeur tombe dans un intervale
sub between {
	return $_[1] <= $_[0] && $_[0] <= $_[2];
}

# lit une chaine de n caract�res depuis le fichier midi
sub read_str {
	my($t, $l);
	($l=read(MIDI, $t, $_[0]))==$_[0] || die "$midi_file: read $l when $_[0] expected: $!, stopped";
	return $t;
}

# lit 1 octet (8bits)
sub read_byte {
	return unpack("C*", &read_str(1));
}

# lit un short (16bits)	
sub read_short {
	my($a, $b) = (&read_byte, &read_byte);
	return $a*256+$b;
}

# lit un long (32bits)
sub read_long {
	my($a, $b) = (&read_short, &read_short);
	return $a*65536+$b;
}

# lit un nombre de longueur variable
sub read_vlv {
	my($n, $s, $t) = (0,0,0);
	do {
		$t = &read_byte;
		$n <<= 7; $n |= $t & 0x7f;
	} while($t & 0x80);
	return $n;
}
