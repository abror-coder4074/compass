# Compass Flutter Windows Prototype TODO

## Ishlash qoidasi

- Har bir bosqich alohida chatda bajarilishi mumkin.
- Bosqichlar bir-biriga bog'liq bo'lsa, keyingi bosqichni boshlashdan oldin oldingi bosqichdagi natijani saqlang.
- Bajarilgan bosqich checkboxi `[x]` ga almashtiriladi.
- Qizil/sariq strelkalar, qizil izoh bloklari, qizil dialog ko'rinishidagi guide yozuvlari va ID/passportga chizilgan guide overlaylar ilova UI qismi emas.
- Screenshotlarda blur qilingan real data Flutter prototipida blur qilinmaydi; uning o'rniga realistik mock data ishlatiladi.
- Compass secure browser/lockdown tajribasini prototipda xavfsiz simulyatsiya qilish kerak: pre-exam ekranlarida oddiy Windows oynasi hissi qoladi, exam boshlanganida fullscreen/kiosk-like `examLockdownMode` yoqiladi, exam tugamaguncha esa faqat finish/timeout/exit flow orqali chiqish ko'rsatiladi.
- Prototip Windows OS darajasida boshqa ilovalarni majburan yopmasin va global shortcutlarni agressiv bloklamasin; haqiqiy OS-level lockdown alohida native/admin security ishi sifatida qaraladi.

## Bosqichlar

- [x] 01. Flutter Windows-only loyiha scaffold qilish
  - Repo rootida Flutter loyiha yaratish.
  - Faqat Windows target kerak: Android, iOS, macOS va web platformalarini yaratmaslik yoki olib tashlash.
  - Windows oynasi title qiymatini `Compass` qilish.
  - Pre-exam bosqichlarida oddiy Compass oynasi bo'lsin: maximize/minimize/resize imkoniyati saqlansin.
  - Actual exam boshlanganda window fullscreen/kiosk-like `examLockdownMode`ga o'tishi uchun window setup tayyorlansin; exam tugaganda normal/score flowga qaytishi mumkin.
  - Windows oynasi HD ekranlarda ham ochilishi kerak: 1366x768 va 1280x720 o'lchamlarda layout buzilmasin; rasmiy manbalarda topilgan `1280x800` wording `Recommended minimum screen resolution`, shuning uchun uni visual/reference target sifatida inobatga oling, lekin appni undan kichik HD balandlikda bloklamang.
  - Pre-exam resize holatida layout sinib ketmasligi uchun minimum window size `1024x700` qilib qo'yish mumkin; actual exam fullscreen bo'lganida content kerak joyda scroll bo'lsin.
  - App presentation-only bo'ladi: API, local database, cubit va bloc ishlatilmaydi.
  - Bosqich yakunida `flutter analyze` ishlashi kerak.

- [x] 02. Global UI shell, theme va assetlar
  - Rasmiy Compass ma'lumotlari asosida phase-aware secure-browser hissini beruvchi `LockdownShell` yoki shunga teng umumiy wrapper yaratish.
  - Pre-exam mode: normal Windows window controls, footer `Close Window`, resize/minimize/maximize mumkin.
  - Exam lockdown mode: fullscreen/kiosk-like, minimize/resize/close urinishlari informational modal yoki disabled holat bilan to'xtatiladi.
  - Exam start paytida qisqa loading/connecting/entering secure exam holati qo'shish mumkin.
  - Certiport portal ko'rinishi uchun umumiy header/footer shell yaratish.
  - Exam engine ko'rinishi uchun alohida top bar/bottom action shell yaratish.
  - Certiport va IC3 logotiplari hamda exam landingdagi katta background/foto guide screenshotlardan crop qilinib asset sifatida tayyorlanadi.
  - Ranglar, typography, buttons, inputs, select/dropdown, switch, radio, table, scroll area va modal komponentlari screenshotlarga yaqinlashtiriladi.
  - App Windows 10 va Windows 11 da normal ko'rinadigan responsive desktop layoutga ega bo'lishi kerak.

- [ ] 03. Login va Certiport portal flow
  - Reference rasmlar: `ic3-start-finish-guide-01.png` dan `ic3-start-finish-guide-12.png` gacha.
  - Login ekrani, language dropdown, username/password inputlari, Login tugmasi va pastki Certiport footer quriladi.
  - Login va pre-exam portal ekranlarida footer `Close Window` linki ko'rinadi va exam boshlanmagan holatda chiqish/log out simulyatsiyasi ishlaydi.
  - Mailing address/cookie flow prototipi quriladi: address form, cookie banner, Accept All Cookies, Continue.
  - Exam readiness sahifasi quriladi: exam group toggle, voucher toggle, voucher input, Next.
  - Select Your Exam sahifasi quriladi: tabs, filter dropdown, search input, voucher card, IC3 exam list, Select exam tugmalari.
  - NDA/Terms sahifasi quriladi: long agreement panel, Yes/No radio, Previous/Next.
  - Buttonlar va inputlar haqiqiy ishlaydigan presentation state bilan ulanadi.

- [ ] 04. Verify/unlock va system-check flow
  - Reference rasmlar: `ic3-start-finish-guide-13.png` dan `ic3-start-finish-guide-18.png` gacha.
  - Verify & Unlock Exam sahifasi quriladi: candidate/exam info table, proctor authentication form, warning row.
  - Proctor username/password inputlari ishlaydi; Continue/Next flow unlock holatiga olib o'tadi.
  - Candidate/proctor sequence rasmiy Compass flowga mos bo'ladi: candidate info verify, proctor authorize, system check, begin exam.
  - System-check sahifasi quriladi: User Admin, Hardware Requirements, Printer Driver, Running Processes, Exam Up to Date, VBScript checklari.
  - Pre-exam landing quriladi: IC3 logo, chap ko'k panel, exam name, time/questions/pass score, o'ngdagi katta foto/background, Tools dropdown va Start Exam tugmasi.
  - Bosqich tugagach `Start Exam` keyingi exam engine flowga o'tishi va appni fullscreen/kiosk-like `examLockdownMode` holatiga o'tkazishi kerak.

- [ ] 05. Test engine flow
  - Reference rasmlar: `ic3-start-finish-guide-19.png` dan `ic3-start-finish-guide-28.png` gacha.
  - Survey sahifasi quriladi: 3 ta rangli answer section va selectable answer cards.
  - Tutorial sahifasi quriladi: scrollable content, IC3 heading strip, Start Exam tugmasi.
  - Question sahifalari quriladi: Question N of 45, Time Remaining, progress bar, blurred emas realistik mock savol matnlari, radio answer options.
  - Bottom navigation quriladi: Go To Summary, Mark for Review, Mark for Feedback, Tools, Back, Next.
  - Exam Summary table quriladi: question number, question content, Answered, Unanswered, Review, Leave Feedback, Finish Exam.
  - 5-Minute Warning va Timeout modallari quriladi.
  - Exam boshlangandan keyingi lockdown simulyatsiyasi ishlaydi: fullscreen/kiosk-like ko'rinish, `Close Window`, window close, minimize/resize yoki logout urinishlari exam tugamaguncha informational modal bilan to'xtatiladi.
  - Timer presentation state bilan ishlaydi yoki demo uchun tezlashtirilgan trigger bilan ko'rsatiladi.

- [ ] 06. Feedback va score report flow
  - Reference rasmlar: `ic3-start-finish-guide-29.png`, `ic3-start-finish-guide-30.png`, `ic3-start-finish-guide-31.png`, `ic3-start-finish-guide-32.png`, va `ic3-start-finish-guide-04.png`.
  - Feedback intro sahifasi quriladi: Skip Feedback va Start Feedback tugmalari.
  - Feedback textarea sahifasi quriladi: prompt matni, katta text area, Next.
  - Thank you/Exit Exam sahifasi quriladi.
  - Exam Score Summary and Pathways sahifasi quriladi: verify email panel, score summary, status Pass, pathways list, footer.
  - Full score report ko'rinishi quriladi: IC3 score report layout, Candidate, Exam, Results, Section Analysis, Final Score, Outcome.
  - Score summary/full reportdan keyin appdan chiqish mumkin bo'lgan yakuniy holat ko'rsatiladi.
  - Score va email/nom data mock bo'ladi, blur qilinmaydi.

- [ ] 07. Final polish va acceptance
  - Barcha bosqichlar yakunida full flow tekshiriladi: login -> address/cookie -> voucher -> exam select -> NDA -> verify -> checks -> start exam -> survey/tutorial -> questions -> summary -> timeout/finish -> feedback -> score.
  - `flutter analyze` xatosiz o'tishi kerak.
  - Windows run tekshiruvi: `flutter run -d windows`.
  - Visual review: header/footer, ranglar, spacing, content width, button joylashuvi, modal o'lchami, table striping, scroll behavior screenshotlarga yaqin bo'lishi kerak.
  - Lockdown simulyatsiyasi tekshiriladi: pre-exam normal window controls, `Start Exam`dan keyin fullscreen/kiosk-like exam mode, exam started holatida close/minimize/resize/logout bloklanishi, finish/timeout/exitdan keyin chiqish.
  - Android, iOS, macOS, web, API, database, cubit/bloc kiritilmaganligi tekshiriladi.
