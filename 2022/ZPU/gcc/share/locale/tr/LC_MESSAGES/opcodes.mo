��    �      �  �   l	      �     �  L   �  K   �  �   $  u   �  �   X  �   �  k   �  }   �  [   u  �   �     _  9   s  3   �  4   �  (        ?     L  !   \     ~     �     �     �  	   �     �  	   �     �          *     >  (   \     �     �     �     �     �          ,     I  &   [  *   �     �  
   �  D   �  C     +   Y  &   �  ,   �     �  :   �  1   0  9   b  6   �     �  "   �  !        2  )   J     t     �  %   �  #   �  +   �  +     1   F  1   x  %   �  +   �  1   �  1   .  %   `  $   �  /   �     �     �          '  .   <  +   k     �     �     �  #   �  7     !   C  !   e  5   �  "   �  +   �       0   '     X     h  "   �     �     �  )   �          *     G  %   b  &   �     �     �     �  !   �  ;        A  +   _  /   �     �     �     �               9     T  !   o  !   �     �  &   �  2   �  2   ,   2   _   0   �   ,   �      �   )   
!     4!     S!     p!  5   �!  $   �!  -   �!  ;   "  $   O"  /   t"  	   �"     �"     �"     �"     �"     �"     �"     #      ,#     M#     f#  5  y#     �$  V   �$  U   %  �   ^%  �   &&  �   �&  �   I'  p   �'  |   _(  _   �(  �   <)     �)  D   �)  #   ,*  0   P*  .   �*     �*     �*  !   �*  
   �*     +     +     1+     O+     \+     |+  %   �+     �+     �+      �+  *   �+     !,  &   9,  "   `,  )   �,     �,  )   �,  &   �,     -  +   ,-  >   X-     �-  
   �-  Q   �-  S   
.  ?   ^.  :   �.  (   �.      /  :   #/  2   ^/  :   �/  7   �/     0  %   #0  +   I0     u0  '   �0  '   �0     �0  -   �0  "   #1  5   F1  6   |1  5   �1  5   �1  5   2  6   U2  4   �2  4   �2  2   �2  ,   )3  ?   V3     �3     �3     �3  3   �3  K   4  K   h4     �4     �4     �4  &   5  9   55  3   o5  '   �5  <   �5  *   6  ?   36  #   s6  3   �6     �6  #   �6     7     !7  #   @7  4   d7     �7  &   �7     �7  -   �7  7   *8     b8     �8  	   �8     �8  0   �8     �8  6   9  ;   B9     ~9     �9     �9     �9     �9     �9     :  &   2:  &   Y:  $   �:  -   �:  8   �:  ;   ;  7   H;  5   �;  3   �;     �;  6   	<  !   @<     b<  !   ~<  4   �<  ,   �<  3   =  :   6=  +   q=  '   �=     �=  
   �=     �=     �=     >     >  "   2>     U>     s>     �>     �>     �          y   �       A   C   ?      z   :   L         �           0   `   �   j   �                k   '   x   �   v   �       I   V   q   h   �   *   8   H       /                   1   Y   +       7   G   a   s           |   ~       c       �      U       $   i      !           t      <   ]   X          5   }   9       �   e       S   ^   f      
   b   �   O      m   �       6               r       -          �              {          �   �      N   #   R   �       (               	   P   �   l   W   >   Q   4   u              n   �   E   p   3   �   w   M       "             �   )                    �       o   F   ;      &   [   d   g   D   2              %   �   ,   Z   \       J          .       K           B              T   _   @   =          
 
  For the options above, The following values are supported for "ARCH":
    
  For the options above, the following values are supported for "ABI":
    
  cp0-names=ARCH           Print CP0 register names according to
                           specified architecture.
                           Default: based on binary being disassembled.
 
  fpr-names=ABI            Print FPR names according to specified ABI.
                           Default: numeric.
 
  gpr-names=ABI            Print GPR names according to  specified ABI.
                           Default: based on binary being disassembled.
 
  hwr-names=ARCH           Print HWR names according to specified 
			   architecture.
                           Default: based on binary being disassembled.
 
  reg-names=ABI            Print GPR and FPR names according to
                           specified ABI.
 
  reg-names=ARCH           Print CP0 register and HWR names according to
                           specified architecture.
 
The following ARM specific disassembler options are supported for use with
the -M switch:
 
The following MIPS specific disassembler options are supported for use
with the -M switch (multiple options should be separated by commas):
 # <dis error: %08x> # internal disassembler error, unrecognised modifier (%c) # internal error, incomplete extension sequence (+) # internal error, undefined extension sequence (+%c) # internal error, undefined modifier(%c) $<undefined> %02x		*unknown* %operator operand is not a symbol %s: Error:  %s: Warning:  (DP) offset out of range. (SP) offset out of range. (unknown) *unknown operands type: %d* *unknown* 21-bit offset out of range <function code %d> <illegal precision> <internal disassembler error> <internal error in opcode table: %s %s>
 <unknown register %d> Address 0x%x is out of bounds.
 Attempt to find bit index of 0 Bad case %d (%s) in %s:%d
 Bad immediate expression Bad register in postincrement Bad register in preincrement Bad register name Byte address required. - must be even. Don't know how to specify # dependency %s
 Don't understand 0x%x 
 Hmmmm 0x%x IC note %d for opcode %s (IC:%s) conflicts with resource %s note %d
 IC note %d in opcode %s (IC:%s) conflicts with resource %s note %d
 IC:%s [%s] has no terminals or sub-classes
 IC:%s has no terminals or sub-classes
 Illegal limm reference in last instruction!
 Internal disassembler error Internal error:  bad sparc-opcode.h: "%s", %#.8lx, %#.8lx
 Internal error: bad sparc-opcode.h: "%s" == "%s"
 Internal error: bad sparc-opcode.h: "%s", %#.8lx, %#.8lx
 Internal: Non-debugged code (test-case missing): %s:%d Label conflicts with `Rx' Label conflicts with register name No relocation for small immediate Operand is not a symbol Small operand was not an immediate number Syntax error: No trailing ')' Unknown error %d
 Unrecognised disassembler option: %s
 Unrecognised register name set: %s
 Unrecognized field %d while building insn.
 Unrecognized field %d while decoding insn.
 Unrecognized field %d while getting int operand.
 Unrecognized field %d while getting vma operand.
 Unrecognized field %d while parsing.
 Unrecognized field %d while printing insn.
 Unrecognized field %d while setting int operand.
 Unrecognized field %d while setting vma operand.
 W keyword invalid in FR operand slot. Warning: rsrc %s (%s) has no chks%s
 attempt to set y bit when using + or - modifier bad instruction `%.50s' bad instruction `%.50s...' branch operand unaligned branch to odd offset branch value not in range and to an odd offset branch value not in range and to odd offset branch value out of range can't cope with insert %d
 can't find %s for reading
 can't find ia64-ic.tbl for reading
 cgen_parse_address returned a symbol. Literal required. class %s is defined but not used
 displacement value is not aligned displacement value is not in range and is not aligned displacement value is out of range don't know how to specify %% dependency %s
 ignoring invalid mfcr mask ignoring least significant bits in branch offset illegal bitmask illegal use of parentheses immediate value cannot be register immediate value is out of range immediate value must be even immediate value not in range and not even immediate value out of range index register in load range invalid conditional option invalid register for stack adjustment invalid register operand when updating jump hint unaligned junk at end of line missing `)' missing mnemonic in syntax string most recent format '%s'
appears more restrictive than '%s'
 multiple note %s not handled
 no insns mapped directly to terminal IC %s
 no insns mapped directly to terminal IC %s [%s] offset greater than 124 offset greater than 248 offset greater than 62 offset not a multiple of 16 offset not a multiple of 2 offset not a multiple of 4 offset not a multiple of 8 offset not between -2048 and 2047 offset not between -8192 and 8191 offset(IP) is not a valid form opcode %s has no class (ops %d %d %d)
 operand out of range (%ld not between %ld and %ld) operand out of range (%ld not between %ld and %lu) operand out of range (%lu not between %lu and %lu) operand out of range (%lu not between 0 and %lu) operand out of range (not between 1 and 255) overlapping field %s->%s
 overwriting note %d with note %d (IC:%s)
 parse_addr16: invalid opindex. register number must be even rsrc %s (%s) has no regs
 source and target register operands must be different source register operand must be even syntax error (expected char `%c', found `%c') syntax error (expected char `%c', found end of instruction) target register operand must be even unable to change directory to "%s", errno = %s
 undefined unknown unknown	0x%02x unknown	0x%04lx unknown	0x%04x unknown constraint `%c' unknown operand shift: %x
 unknown pop reg: %d
 unrecognized form of instruction unrecognized instruction value out of range Project-Id-Version: opcodes 2.14rel030712
PO-Revision-Date: 2003-07-13 22:58+0300
Last-Translator: Deniz Akkus Kanca <deniz@arayan.com>
Language-Team: Turkish <gnu-tr-u12a@lists.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Generator: KBabel 1.0
 
 
  Yukarıdaki seçeneklere göre "ARCH" için aşağıdaki değerler desteklenir:
    
  Yukarıdaki seçeneklere göre "ABI" için aşağıdaki değerler desteklenir:
    
  cp0-names=MİMARİ         Belirtilen mimariye göre CP0 yazmaç isimlerini
                           gösterir.
                           Öntanımlı: karşıt-çevrilen ikilik dosyaya göre.
 
  fpr-names=ABI            Belirtilen ABI'ye göre FPR isimlerini gösterir.
                           Öntanımlı: sayısal.
 
  gpr-names=ABI            Belirtilen ABI'ye göre GPR isimlerini gösterir.
                           Öntanımlı: karşıt-çevrilen ikilik dosyaya göre.
 
  hwr-names=MİMARİ         Belirtilen mimariye göre HWR isimlerini gösterir.
                           Öntanımlı: karşıt-çevrilen ikilik dosyaya göre.
 
  reg-names=ABI            Belirtilen ABI'ye göre GPR ve FPR isimlerini
                           gösterir.
 
  reg-names=MİMARİ         Belirtilen mimariye göre CP0 yazmaç ve HWR
                           isimlerini gösterir.
 
Aşağıdaki ARM'a özgü karşıt-çevirici seçenekleri 
-M seçeneği ile kullanılabilir:
 
Aşağıdaki MIPS'e özgü karşıt-çevirici seçenekleri 
-M seçeneği ile kullanılabilir (birden fazla seçenek virgülle ayrılmalıdır):
 # <`dis' hatası: %08x> #iç karşıt-çevirici hatası, tanımlanmamış değiştirici (%c) # iç hata, eksik uzatma dizisi (+) # iç hata, tanımlanmamış uzatma dizisi (+%c) #iç hata, tanımlanmamış değiştirici (%c) $<tanımlanmamış> %02x		*bilinmeyen* %operator işleneni sembol değil %s: Hata:  %s: Uyarı:  (DP) görecesi aralık dışı. (SP) görece aralık dışı. (bilinmeyen) bilinmeyen işlenen türü: %d* *bilinmeyen* 21 bit görece değer aralık dışı <işlev kodu %d> <geçersiz kesinlik> <iç karşıt-çevirici hatası> <işlemci kod tablosunda iç hata: %s %s>
 <bilinmeyen yazmaç %d> 0x%x adresi sınırların dışında.
 0'ın bit indeksini bulma denemesi Hatalı durum %d (%s), %s içerisinde:%d
 Hatalı şimdiki ifade Arttırma sonrasında  geçersiz yazmaç  Arttırma öncesinde geçersiz yazmaç Geçersiz yazmaç adı Bayt adresi gerekli. - çift sayı olmalı. # %s bağımlılığının nasıl tanımlanacağı bilinmiyor
 0x%x anlaşılamadı
 Hmmmm 0x%x (IC:%3$s) opkod %2$s için IC notu %1$d, %4$s kaynağı %5$d notuyla çelişiyor
 (IC:%3$s) opkod %2$s içinde IC notu %1$d, %4$s kaynağı %5$d notuyla çelişiyor
 IC: %s [%s]'nin değişmez simgeleri veya alt sınıfları yok
 IC: %s'nin değişmez simgeleri veya alt sınıfları yok
 Son işlemde geçersiz limm referansı!
 İç karşıt-çevirici hatası  İç hata: geçersiz sparc-opcode.h: "%s", %#.8lx, %#.8lx
 İç hata: geçersiz sparc-opcode.h: "%s" == "%s"
 İç hata: geçersiz sparc-opcode.h: "%s", %#.8lx, %#.8lx
 İç Hata: Hata ayıklanmamış kod (test eksik): %s:%d Etiket, `Rx' ile çakışıyor Etiket, yazmaç adıyla çakışıyor Küçük şimdiki için yerdeğiştirme yok İşlenen bir sembol değil Küçük işlenen şimdiki sayı değil Sözdizim hatası: Sonlandıran ')' yok Bilinmeyen hata %d
 Bilinmeyen karşıt-çevirici seçeneği: %s
 Bilinmeyen yazmaç ad kümesi: %s
 Yönerge oluşturulurken bilinmeyen alan %d bulundu.
 Yönerge çözümlenirken bilinmeyen alan %d bulundu.
 `int' terimi alınırken bilinmeyen alan %d bulundu.
 `vma' terimi alınırken bilinmeyen alan %d bulundu.
 Ayrıştırma esnasında bilinmeyen alan %d bulundu.
 yönerge yazdırılırken bilinmeyen alan %d bulundu.
 `int' terimi atanırken bilinmeyen alan %d bulundu.
 `vma' terimi atanırken bilinmeyen alan %d bulundu.
 FR işlenen slotunda W anahtar kelimesi geçersiz. Uyarı: rsrc %s (%s) içinde kontrol yok %s
 + veya - değiştiricisini kullanırken y bitini atama denemesi geçersiz işlem `%.50s' geçersiz işlem `%.50s...' dal işleneni hizalı değil dallanma tek sayılı göreli konuma işaret ediyor dal değeri kapsam dışında ve tek sayılı göreli konuma işaret ediyor dal değeri kapsam dışında ve tek sayılı göreli konuma işaret ediyor dal değeri kapsam dışında  insert %d yaptırılamıyor
 %s okunmak için bulunamadı
 ia64-ic.tbl okunmak için bulunamadı
 cgen_parse_address bir sembol döndürdü. Sabit gerekli. %s sınıfı tanımlanmış fakat kullanılmamış
 yer değiştirme değeri hizalanmamış yer değiştirme değeri kapsam dışında ve hizalanmamış yer değiştirme değeri kapsam dışında %% %s bağımlılığının nasıl tanımlanacağı bilinmiyor
 geçersiz mfcr maskesi yoksayıldı Dal göreli konumunda en önemsiz bitler atlanıyor geçersiz bitmask  parantezlerin geçersiz kullanımı şimdiki değer yazmaç olamaz şimdiki değer kapsam dışı şimdiki değer çift sayı olmalı şimdiki değer kapsam dışı ve çift sayı değil şimdiki değer kapsam dışı yükleme aralığında endeks yazmacı koşullu seçenek geçersiz  yığıt düzeltmesi için geçersiz yazmaç  güncelleme esnasında geçersiz yazmaç terimi bulundu atlama işareti hizalı değil Satır sonu bozuk  eksik `)' biçem dizgesinde ipucu eksik en son biçem '%s'
'%s'dan daha kısıtlayıcı
 çoklu not %s desteklenmiyor
 değişmez simge IC %s'ye direkt eşleşen işlem yok
 değişmez simge IC %s [%s]'ye direkt eşleşen işlem yok  görece 124'ten büyük görece 248'den büyük görece 62'den büyük görece 16'nın katı değil görece 2'nin katı değil görece 4'ün katı değil görece 8'in katı değil görece -2048 ve 2047 arasında değil görece -8192 ve 8191 arasında değil görece(IP) geçerli biçimde değil %s opkodunun sınıfları yok (ops %d %d %d)
 Kapsam dışı terim (%ld, %ld ve %ld arasında değil)  Kapsam dışı işlenen (%ld, %ld ve %lu arasında değil)  Kapsam dışı terim (%lu, %lu ve %lu arasında değil) kapsam dışı terim (%lu 0 ve %lu arasında değil)  kapsam dışı işlenen (1 ve 255 arasında değil) üstüste binmiş alan %s->%s
 %2$d notu %1$d notunun üstüne yazılıyor (IC:%3$s)
 parse_addr16: geçersiz opindeks. yazmaç çift sayı olmalı rsrc %s (%s) içinde yazmaç yok
 kaynak ve hedef yazmaç işlenenleri farklı olmalı kaynak yazmaç işleneni çift sayı olmalı biçem hatası (char `%c' beklenirken `%c' bulundu) biçem hatası (char `%c' beklenirken işlem sonu bulundu) hedef yazmaç işleneni çift sayı olmalı "%s" dizinine geçilemedi, hatano = %s
 tanımlanmamış bilinmeyen bilinmeyen	0x%02x bilinmeyen	0x%04lx bilinmeyen	0x%04x `%c' bilinmeyen kısıtı bilinmeyen terim kaydırması: %x
 bilinmeyen çek yazmacı: %d
 bilinmeyen işlem türü bilinmeyen işlem değer aralık dışı 