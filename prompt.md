# Compass Flutter Windows Prototype Prompts

## Umumiy kontekst

Quyidagi kontekstni har bir bosqich chatida yuboring.

```text
Maqsad: `ic-guide/` ichidagi 32 ta screenshot asosida Certiport Compass ilovasining Flutter Windows prototipini yaratish. Ilova presentation-only bo'ladi: haqiqiy ishlaydigan tugmalar, inputlar, dropdownlar, radio/switchlar, scroll, modal va navigation bo'ladi, lekin API, local database, cubit va bloc ishlatilmaydi.

Target: faqat Windows desktop. Android, iOS, macOS va web kerak emas. Asosiy target Windows 10 va Windows 11. Windows oynasi title `Compass` bo'lishi kerak.

Rasmiy Compass konteksti: Compass Certiport/Pearson VUE exam delivery sistemi bo'lib, secure browser tajribasiga ega. Candidate odatda CATC markazida proctor bilan bir xonada bo'ladi. Launch pathway mantiqi: login -> exam group/voucher -> NDA/terms -> registration/selection -> verify information -> proctor validate/authorize -> system check/begin exam -> tutorial -> timed questions -> finish/feedback -> score report.

Lockdown talabi: bu prototip Compass for Windows screenshotlariga asoslangan. Pre-exam bosqichlarda oddiy Windows oynasi hissi saqlanadi: maximize/minimize/resize va footer `Close Window` mumkin. Actual exam boshlanganda (`Start Exam`/exam questions phase) app fullscreen/kiosk-like `examLockdownMode`ga o'tadi; shu holatda close/minimize/resize/logout urinishlari informational modal bilan bloklanadi va candidate exam tugaguncha yoki timeout bo'lguncha chiqa olmaydi. Rasmiy Certiport Browser Lockdown ma'lumotlarida lockdown exam start paytida ishga tushishi va test vaqtida boshqa oynalar accessible emasligi yozilgan; Compass Cloud hujjatlarida esa lockdown desktop app launch paytida boshlanishi aytilgan. Shu farq sababli ushbu Windows prototipda pre-exam normal, actual exam esa lockdown/fullscreen-like bo'ladi. Windows OS darajasida boshqa ilovalarni majburan yopish, Alt+Tabni haqiqiy global hook bilan ushlash yoki admin-level security o'zgarishlari presentation prototype scopeiga kirmaydi.

1:1 talab: screenshotlardagi Compass/Certiport UI ranglari, spacing, layout, content width, header/footer, button/input/table/modal holatlari, scrollbars va elementlar joylashuvi maksimal darajada o'xshatiladi. Ilova ochilganda Compass bilan farqi sezilmasligi kerak.

Muhim: qizil strelkalar, qizil yozuvli guide bloklar/dialoglar, sariq strelka va ID/passport ustidagi guide chiziqlar ilova UI qismi emas. Ular faqat workflowni tushuntirish uchun screenshot ustiga qo'shilgan annotationlar. Flutter UI ichida ularni chizmang.

Blur qilingan data: screenshotlarda atayin blur qilingan shaxsiy/email/savol data prototipda blur qilinmaydi. Uning o'rniga realistik, xavfsiz mock data ishlating. Masalan: ism/familiya, email, voucher, score, exam question content va candidate address mock bo'lishi mumkin.

Assetlar: Certiport/IC3 logotiplari va exam landingdagi katta foto/background 1:1 o'xshashlik uchun `ic-guide/` screenshotlaridan crop qilib lokal asset sifatida ishlatiladi. Tashqi network asset ishlatmang.

State boshqaruvi: cubit/bloc yo'q. Oddiy `StatefulWidget`, controller, local model class yoki `ValueNotifier` yetarli. Data app ichida hardcoded mock bo'lishi mumkin.

Har bosqich oxirida tegishli checkbox `todo.md` ichida `[x]` qilinadi va imkon bo'lsa `flutter analyze` ishlatiladi.
```

## Rasmiy research eslatmalari

- Compass for Windows User Guide: https://certiport.pearsonvue.com/Support/PDFs/Compass/Compass-User-Guide-Windows.pdf
  - Compass secure browser orqali Certiport exam launch qilishini, CATC/proctor muhitini va candidate flowini tasdiqlaydi.
  - Voucherlar case-sensitive va dash bilan kiritilishi kerakligi, NDA accept sharti, proctor authorization, system check, tutorialdan keyin timer boshlanishi va score report flowi shu guidega moslashtiriladi.
- Compass Cloud Test Candidate Guide: https://certiport.pearsonvue.com/Support/Install/Compass-Cloud/Test-Candidate/CC_Guide_TestCandidate
  - Lockdown xatti-harakati aniq yozilgan: app launchdan keyin boshqa dasturlarga o'tish cheklanadi; exam boshlanmaguncha `Close Window`/logout mumkin; actual examdan keyin finish yoki timeoutgacha chiqib bo'lmaydi.
  - Ekran o'lchami bo'yicha wording `Recommended minimum screen resolution of 1280 x 800`, ya'ni prototipda `1280x800` reference target bo'ladi, lekin HD 1366x768 yoki 1280x720 ekranlarda appni hard-block qilish kerak emas.
- Certiport Browser Lockdown Support: https://www.certiport.com/portal/common/pagelibrary/browser_lockdown.htm
  - Browser Lockdown exam start paytida ishga tushishi va exam tugagandan keyin lock qolib ketsa release utility kerak bo'lishi mumkinligi yozilgan.
- Certiport assessment/test sahifalari:
  - https://www.certiport.com/portal/desktopdefault.aspx?page=common%2Fpagelibrary%2FCap_exam_L1.htm
  - https://www.certiport.com/portal/desktopdefault.aspx?page=common%2Fpagelibrary%2FWelcome_Aboard.htm
  - Bu sahifalarda test/assessment vaqtida boshqa oynalar accessible emasligi yozilgan. Shu asosda actual exam phase fullscreen/kiosk-like lockdown sifatida prototiplanadi.
- Window policy: pre-exam normal window controls + minimum `1024x700`; actual exam phase fullscreen/kiosk-like. Manbalarda exact fullscreen wording topilmagan, lekin boshqa oynalarga o'tish bloklanishi aniq.
- Pearson/Certiport Compass listing: https://appsource.microsoft.com/en-us/product/saas/pearsonvue.pearsonvuecompass
  - Compass web-based, secure browser-based, Azure-backed exam delivery system sifatida tasvirlangan.

## Bosqich 01 prompti: Flutter Windows-only loyiha scaffold qilish

```text
@todo.md dagi "01. Flutter Windows-only loyiha scaffold qilish" bosqichni bajar.

Umumiy kontekst:
[prompt.md dagi "Umumiy kontekst" bo'limini shu yerga qo'ying]

Bosqichga aloqador kontekst:
Repo hozir `ic-guide/` rasmlaridan iborat. Flutter loyiha rootda yaratilishi kerak. Faqat Windows target kerak. Android, iOS, macOS va web yaratilmasin yoki yaratilgan bo'lsa olib tashlansin. App title `Compass` bo'lsin. Pre-exam bosqichlarda oddiy Windows oynasi controls saqlansin: minimize/maximize/resize mumkin. Non-fullscreen/pre-exam resize uchun minimum window size `1024x700` qo'yish mumkin. Actual exam boshlanganda (`Start Exam`dan keyin) window fullscreen/kiosk-like `examLockdownMode`ga o'tsin; exam tugaganda/timeout/score flowdan keyin normal exit holatiga qaytsin. Rasmiy manbalarda `1280x800` `Recommended minimum screen resolution` sifatida ko'rsatilgan, hard requirement sifatida emas; prototip HD ekranlarda ham ochilishi kerak: 1366x768 va 1280x720 o'lchamlarda layout buzilmasin, kerak joylarda scroll/responsive scaling ishlating, appni 800px balandlikdan pastda hard-block qilmang. OS-level admin security yoki global hooklar qo'shilmasin. API, local database, cubit va bloc qo'shilmasin. Bosqich yakunida `todo.md` dagi 01-bosqich `[x]` qilinsin va `flutter analyze` bilan tekshirilsin.
```

## Bosqich 02 prompti: Global UI shell, theme va assetlar

```text
@todo.md dagi "02. Global UI shell, theme va assetlar" bosqichni bajar.

Umumiy kontekst:
[prompt.md dagi "Umumiy kontekst" bo'limini shu yerga qo'ying]

Bosqichga aloqador kontekst:
Bu bosqich keyingi barcha ekranlar uchun umumiy dizayn asosini yaratadi. Phase-aware secure browser hissini beruvchi umumiy `LockdownShell` yoki teng wrapper yarating. Pre-exam mode oddiy Windows oynasi kabi bo'lsin: resize/minimize/maximize mumkin, `Close Window` chiqish/log out simulyatsiyasini qiladi. Exam mode (`examLockdownMode`) fullscreen/kiosk-like bo'lsin: close/minimize/resize/logout urinishlari informational modal bilan bloklanadi. Exam modega o'tishda qisqa loading/entering secure exam visual state bo'lishi mumkin. Haqiqiy OS-level app termination yoki global shortcut bloklash qilmang.

Certiport portal flow uchun header/footer shell kerak: yuqorida Certiport logo, o'ngda megaphone icon va user/language joyi, kulrang page background, oq content container, pastda teal footer va version/copyright/linklar. Exam engine flow uchun alohida shell kerak: och kulrang top area, oq content, pastki action bar, Tools dropdown, qoramtir ko'k primary buttonlar.

Assetlar screenshotlardan crop qilinadi:
- Certiport logo: `ic3-start-finish-guide-01.png`, `05-16.png`, `31-32.png` dan.
- IC3 logo: `ic3-start-finish-guide-04.png`, `17-20.png`, `29-30.png` dan.
- Exam landing background/foto: `ic3-start-finish-guide-17.png` yoki `18.png` dan.

Komponentlar: primary button, secondary button, disabled button, text input, password input, dropdown/select, switch/toggle, radio, warning/info card, table rows, modal dialog, scrollable panel, lockdown/exit modal. Ranglar screenshotga yaqin bo'lsin: Certiport teal, dark navy, light gray backgrounds, white cards, gray borders. Bosqich yakunida `todo.md` dagi 02-bosqich `[x]` qilinsin va `flutter analyze` ishlatilsin.
```

## Bosqich 03 prompti: Login va Certiport portal flow

```text
@todo.md dagi "03. Login va Certiport portal flow" bosqichni bajar.

Umumiy kontekst:
[prompt.md dagi "Umumiy kontekst" bo'limini shu yerga qo'ying]

Bosqichga aloqador kontekst:
Reference rasmlar: `ic3-start-finish-guide-01.png` dan `ic3-start-finish-guide-12.png` gacha. Qizil/sariq annotationlar UI emas.

Kerakli ekranlar va interactionlar:
1. Login screen: Compass window, Certiport logo, language dropdown, username/password input, Login button, "Or login with" Certiport C button, support/tutorial links, teal footer va `Close Window`. Login bosilganda portal readiness screen ochiladi.
2. Address/cookie flow: `02-03` reference asosida mailing address formasi, cookie banner, Accept All Cookies va Continue. Browser chrome UI to'liq shart emas, lekin portal content 1:1 ko'rinishi kerak.
3. Readiness screen: `05-08` reference. "Welcome Certiport..." heading, Exam Group ID toggle default No, Voucher toggle, voucher Yes holati, assigned voucher dropdown, voucher input, Next. Voucher input uppercase/hyphen formatdagi mock value bilan ishlasin.
4. Exam select: `09` reference. Search full list tab active, Help me find my exam tab, All programs dropdown, search input, voucher card, IC3 Digital Literacy Certification section, uch exam row va Select exam buttons.
5. NDA/Terms: `10-12` reference. Agreement box, Yes/No radio, Previous, Next. Default No bo'lsa Next disabled, Yes tanlanganda active.

Navigation: Login -> readiness -> voucher -> select exam -> NDA. Previous buttonlar orqaga qaytsin. Pre-exam holatda `Close Window` chiqish/log out simulyatsiyasini ko'rsatsin. Bosqich yakunida `todo.md` dagi 03-bosqich `[x]` qilinsin va `flutter analyze` ishlatilsin.
```

## Bosqich 04 prompti: Verify/unlock va system-check flow

```text
@todo.md dagi "04. Verify/unlock va system-check flow" bosqichni bajar.

Umumiy kontekst:
[prompt.md dagi "Umumiy kontekst" bo'limini shu yerga qo'ying]

Bosqichga aloqador kontekst:
Reference rasmlar: `ic3-start-finish-guide-13.png` dan `ic3-start-finish-guide-18.png` gacha. Qizil annotationlar UI emas.

Kerakli ekranlar va interactionlar:
1. Verify & Unlock Exam: title, warning/info card, Candidate & Exam Information table, candidate mock name, exam details, test center `Edu Action LLC.`, payment type `Voucher`, proctor authentication panel.
2. Proctor form: username/password inputlari ishlaydi. Mock username/password kiritilganda yoki demo submit bosilganda system-check sahifasiga o'tadi.
3. System-check screen: `IC3 GS6 Level 1` title, checkmark list: User Admin, Hardware Requirements, Printer Driver, Running Processes, Exam Up to Date, VBScript. Previous va Next buttons. Next pre-exam landingga o'tadi.
4. Pre-exam landing: IC3 logo, chap dark navy panel, "Welcome, Certiport!", exam name, maximum exam time 50 minutes, 45 questions, pass score 700. O'ng tomonda crop qilingan katta foto/background. Pastda Tools dropdown va Start Exam button. Start Exam keyingi test engine flowga ulansin va app state `examStarted=true`, `examLockdownMode=true` bo'lsin.
5. Rasmiy Compass flowga mos ravishda tutorialdan oldingi portal/unlock bosqichlarida `Close Window` hali mumkin, lekin `Start Exam` bosilgandan keyin fullscreen/kiosk-like exam modega o'tib normal chiqish bloklanadi.

Bosqich yakunida `todo.md` dagi 04-bosqich `[x]` qilinsin va `flutter analyze` ishlatilsin.
```

## Bosqich 05 prompti: Test engine flow

```text
@todo.md dagi "05. Test engine flow" bosqichni bajar.

Umumiy kontekst:
[prompt.md dagi "Umumiy kontekst" bo'limini shu yerga qo'ying]

Bosqichga aloqador kontekst:
Reference rasmlar: `ic3-start-finish-guide-19.png` dan `ic3-start-finish-guide-28.png` gacha. Qizil/sariq annotationlar UI emas. Screenshotlarda savol matnlari blur qilingan, lekin appda blur qilinmasin; realistik mock savollar yozilsin.

Kerakli ekranlar va interactionlar:
1. Survey 1 of 1: description text, dot indicator, Answer Area, 3 ta rangli section. Birinchi section dark navy, ikkinchi green, uchinchi teal. Har section ichida selectable light-gray cards. Next button tutorialga o'tadi.
2. Tutorial: scrollable content, IC3 Digital Literacy GS6 Level 1 dark navy heading strip, exam process text, sample question image/layout ko'rinishi, bottom Tools va Start Exam button. Start Exam question pagega o'tadi.
3. Question pages: `Question N of 45`, `Time Remaining`, progress bar, savol matni, A-D radio answer options. Bottom links: Go To Summary, Mark for Review, Mark for Feedback, Tools. Back va Next buttons. Answer tanlansa summary state yangilansin.
4. Go To Summary: Exam Summary table ochadi. Columns: Question Number, Question Content, Answered, Unanswered, Review, Leave Feedback. Answered/Unanswered countlar demo state bo'yicha o'zgaradi.
5. Finish Exam: feedback introga o'tadi.
6. 5-Minute Warning modal: dark navy modal, title `5-Minute Warning`, text `You have 5 minutes remaining.`, Continue button. Demo trigger summary yoki timer state orqali ko'rsatilishi mumkin.
7. Timeout modal: dark navy modal, title `Timeout`, text `You have reached the maximum test time. Click Finish Exam to continue to the Exam Summary.`, Finish Exam button.
8. Lockdown simulyatsiyasi: question/tutorial/summary/feedbackgacha bo'lgan exam-started holatlarida window fullscreen/kiosk-like bo'lsin; window close, minimize, resize, logout yoki `Close Window` bosilsa `You cannot exit until the exam has been completed or timed out.` mazmunidagi Compass uslubidagi modal chiqsin. Finish Exam yoki Timeout keyingi feedback/score flowga o'tkazadi.

Timer presentation-only bo'lsin: real 50 daqiqa kutishga majbur qilmasin, lekin countdown/timer ko'rinishi ishlasin. Rasmiy guidega mos ravishda timer tutorialdan keyin, savollar boshlanganida yuradi. Bosqich yakunida `todo.md` dagi 05-bosqich `[x]` qilinsin va `flutter analyze` ishlatilsin.
```

## Bosqich 06 prompti: Feedback va score report flow

```text
@todo.md dagi "06. Feedback va score report flow" bosqichni bajar.

Umumiy kontekst:
[prompt.md dagi "Umumiy kontekst" bo'limini shu yerga qo'ying]

Bosqichga aloqador kontekst:
Reference rasmlar: `ic3-start-finish-guide-29.png`, `ic3-start-finish-guide-30.png`, `ic3-start-finish-guide-31.png`, `ic3-start-finish-guide-32.png`, va `ic3-start-finish-guide-04.png`. Qizil annotationlar UI emas. Blur qilingan email/score/candidate data mock data bilan blur qilinmasdan ko'rsatiladi.

Kerakli ekranlar va interactionlar:
1. Feedback intro: IC3 logo top-left, title `Leave feedback about exam items`, bir nechta explanatory paragraph, bottom Tools, Skip Feedback va Start Feedback buttons. Skip Feedback score summaryga o'tadi, Start Feedback textarea sahifasiga o'tadi.
2. Feedback textarea: title, numbered prompt list, katta textarea, bottom Tools, Next. Next thank-you pagega o'tadi.
3. Thank-you page: `Thank you for taking the IC3 Digital Literacy GS6 Level 1 exam.`, bottom Tools, Exit Exam. Exit score summaryga o'tadi.
4. Exam Score Summary and Pathways: Certiport portal shell, Verify Email Address panel, Update Email Address button, mock email, Exam Score Summary table, score `700/1000`, status `Pass`, View Full Score Report button, Pathways section va View Pathways Details buttons.
5. Full score report: `ic3-start-finish-guide-04.png` asosida IC3 score report layout. Candidate panel, Exam panel, Results score grid, Section Analysis, Final Score, Outcome Pass check. Screenshotdagi guide strelka UI emas. Realistic mock candidate data ko'rsatilsin.
6. Score report ko'rsatilgandan keyin app state `examStarted=false` bo'lishi mumkin va foydalanuvchi yakuniy exit/close flow orqali chiqishi mumkin.

Bosqich yakunida `todo.md` dagi 06-bosqich `[x]` qilinsin va `flutter analyze` ishlatilsin.
```

## Bosqich 07 prompti: Final polish va acceptance

```text
@todo.md dagi "07. Final polish va acceptance" bosqichni bajar.

Umumiy kontekst:
[prompt.md dagi "Umumiy kontekst" bo'limini shu yerga qo'ying]

Bosqichga aloqador kontekst:
Butun appni yakuniy tekshir. Full flow ishlashi kerak: login -> address/cookie -> voucher -> exam select -> NDA -> verify -> checks -> start exam -> survey -> tutorial -> questions -> summary -> timeout/finish -> feedback -> score summary -> full score report.

Tekshiruvlar:
- `flutter analyze` xatosiz o'tsin.
- `flutter run -d windows` bilan Windows app ochilsin.
- Windows title `Compass` bo'lsin.
- Lockdown simulyatsiyasi ishlasin: pre-exam normal window controls, `Start Exam`dan keyin fullscreen/kiosk-like exam mode, exam started holatida close/minimize/resize/logout bloklanishi, finish/timeout/score reportdan keyingi exit.
- Android, iOS, macOS, web targetlar yo'q yoki ishlatilmaydi.
- API, local database, cubit/bloc ishlatilmagan.
- Qizil/sariq annotationlar UIga kiritilmagan.
- Blur qilingan data appda blur qilinmagan, mock data bilan almashtirilgan.
- Certiport/IC3 logo va exam landing foto/background lokal assetdan ishlatilgan.
- Header/footer, color, spacing, buttons, inputs, modals, tables, scrollbars screenshotlarga maksimal yaqin.

Topilgan visual yoki flow muammolarni shu bosqichda tuzat. Yakunda `todo.md` dagi 07-bosqich `[x]` qilinsin.
```
