import 'exam_models.dart';

const tutorialExamTitle = 'IC3 Digital Literacy GS6 Level 1';

const surveyCourseOptions = [
  SurveyOption(
    id: 1,
    label: 'I have not taken a course that covers Digital Literacy.',
  ),
  SurveyOption(
    id: 2,
    label: 'I am beginning my first course that covers Digital Literacy.',
  ),
  SurveyOption(
    id: 3,
    label:
        'I have completed or nearly completed my first course that covers Digital Literacy.',
  ),
  SurveyOption(
    id: 4,
    label: 'I have completed multiple courses that cover Digital Literacy.',
  ),
];

const surveyResourceOptions = [
  SurveyOption(id: 11, label: 'Online learning or video'),
  SurveyOption(id: 12, label: 'Instructor-led learning'),
  SurveyOption(id: 13, label: 'Hands-on practice or labs'),
  SurveyOption(id: 14, label: 'Practice tests'),
];

const surveyUsageOptions = [
  SurveyOption(id: 21, label: 'I am studying Digital Literacy for class.'),
  SurveyOption(
    id: 22,
    label:
        'I use my Digital Literacy skills non-professionally (hobbies, interests, etc).',
  ),
  SurveyOption(
    id: 23,
    label: 'I use my Digital Literacy skills professionally.',
  ),
  SurveyOption(id: 24, label: 'I teach others Digital Literacy.'),
];

List<ExamQuestion> buildMockExamQuestions() {
  final seeds = <({String prompt, List<String> options})>[
    (
      prompt:
          'Which action best protects a shared classroom laptop from unauthorized access?',
      options: [
        'Leave the device signed in so the next student can continue quickly.',
        'Use a unique password and lock the screen before walking away.',
        'Save the password in a sticky note attached to the display.',
        'Disable sign-in prompts to reduce interruptions during class.',
      ],
    ),
    (
      prompt:
          'A student needs to organize project files for three different subjects. Which approach is best?',
      options: [
        'Store every file in Downloads so everything is in one place.',
        'Create a folder for each subject and use clear file names.',
        'Rename every file to Final Project to keep names short.',
        'Keep files on the desktop until the semester ends.',
      ],
    ),
    (
      prompt:
          'Which example shows a strong password practice for a school portal account?',
      options: [
        'Use the same password as the student email account.',
        'Share the password with a classmate for backup access.',
        'Create a long password phrase that is not easy to guess.',
        'Write the password inside the front cover of the notebook.',
      ],
    ),
    (
      prompt:
          'What is the safest response to an email asking for account credentials?',
      options: [
        'Reply with the username only to confirm the account exists.',
        'Open the link and verify the request in a browser tab.',
        'Forward the email to friends to see if it looks legitimate.',
        'Report the message as suspicious and do not provide credentials.',
      ],
    ),
    (
      prompt:
          'A browser displays a padlock icon next to a website address. What does this usually indicate?',
      options: [
        'The site cannot track browsing activity.',
        'The connection between the browser and site is encrypted.',
        'The site has no advertisements or cookies.',
        'The page can be edited only by administrators.',
      ],
    ),
    (
      prompt:
          'Which file type is most appropriate for a presentation that needs slides, transitions, and speaker notes?',
      options: [
        'Spreadsheet file',
        'Presentation file',
        'Compressed archive file',
        'Plain text file',
      ],
    ),
    (
      prompt: 'Why is it useful to use headings and styles in a long document?',
      options: [
        'They allow the document to ignore spelling and grammar checks.',
        'They make text larger while removing the need for titles.',
        'They help organize content and improve navigation.',
        'They prevent other users from viewing the document.',
      ],
    ),
    (
      prompt:
          'A student wants to compare monthly club expenses. Which tool should they use?',
      options: [
        'A spreadsheet with rows, columns, and formulas',
        'A drawing program with shape tools',
        'A photo editor with filters',
        'A music player playlist',
      ],
    ),
    (
      prompt:
          'Which spreadsheet formula adds the values in cells B2 through B6?',
      options: ['=TOTAL(B2:B6)', '=ADD(B2,B6)', '=SUM(B2:B6)', '=VALUE(B2:B6)'],
    ),
    (
      prompt:
          'What is the main purpose of cloud storage in a digital workflow?',
      options: [
        'To automatically print files from any device',
        'To store files online so they can be accessed and shared',
        'To replace the need for passwords on all devices',
        'To convert documents into presentation slides',
      ],
    ),
    (
      prompt:
          'Which action is the best way to credit a photo used in a school report?',
      options: [
        'Remove the creator name so the page looks cleaner.',
        'List the source according to the teacher or school guidelines.',
        'Use the photo without mention because it is on the internet.',
        'Change the color of the photo and claim it as original.',
      ],
    ),
    (
      prompt:
          'A student is collaborating on a shared document. What should they do before editing a classmate\'s section?',
      options: [
        'Delete the old section and rewrite it immediately.',
        'Use comments or suggestions to coordinate changes.',
        'Rename the document so the classmate cannot find it.',
        'Download a copy and edit offline without informing anyone.',
      ],
    ),
    (
      prompt:
          'Which device component is primarily responsible for temporarily holding active data while programs are running?',
      options: ['RAM', 'Monitor', 'Printer', 'Speakers'],
    ),
    (
      prompt: 'What is the most appropriate use of a presentation theme?',
      options: [
        'To apply a consistent design across slides',
        'To hide slide numbers from the presenter',
        'To replace the need for speaker notes',
        'To automatically write the speech script',
      ],
    ),
    (
      prompt:
          'Which practice best helps prevent malware infections on a personal computer?',
      options: [
        'Download files only from trusted sources and keep software updated.',
        'Disable all updates so apps do not change unexpectedly.',
        'Open every email attachment to confirm it is safe.',
        'Turn off antivirus software during daily use.',
      ],
    ),
    (
      prompt:
          'A class survey needs a quick visual comparison of response totals. Which chart works best?',
      options: [
        'Bar chart',
        'Footnote list',
        'Document margin note',
        'Paragraph indentation',
      ],
    ),
    (
      prompt: 'Which keyboard shortcut commonly copies selected text or files?',
      options: ['Ctrl+C', 'Ctrl+P', 'Ctrl+Z', 'Ctrl+F'],
    ),
    (
      prompt: 'Why should software updates be installed regularly?',
      options: [
        'They can improve security and fix known issues.',
        'They permanently increase battery size.',
        'They remove the need for data backups.',
        'They prevent the use of cloud storage.',
      ],
    ),
    (
      prompt:
          'A student receives feedback in a document review pane. What is the best next step?',
      options: [
        'Ignore the comments and submit the document unchanged.',
        'Review the comments and apply appropriate revisions.',
        'Delete the comment history before reading it.',
        'Convert the document to an image to avoid edits.',
      ],
    ),
    (
      prompt:
          'Which online search phrase is most likely to return targeted results about spreadsheet charts?',
      options: [
        'stuff charts maybe',
        'spreadsheet chart tutorial for beginners',
        'random office school project',
        'internet things with bars',
      ],
    ),
    (
      prompt:
          'What is the main benefit of using version history in a cloud document?',
      options: [
        'It lets the document bypass sharing permissions.',
        'It removes the need to save changes manually forever.',
        'It helps recover or review earlier edits.',
        'It hides the document from collaborators.',
      ],
    ),
    (
      prompt:
          'Which behavior is appropriate when participating in an online class discussion forum?',
      options: [
        'Use respectful language and stay on topic.',
        'Post the same message several times for visibility.',
        'Share private contact details of other students.',
        'Type in all caps to show urgency.',
      ],
    ),
    (
      prompt: 'What does a web browser bookmark allow a user to do?',
      options: [
        'Translate every page automatically',
        'Return quickly to a saved website',
        'Repair a slow internet connection',
        'Encrypt local files on the computer',
      ],
    ),
    (
      prompt:
          'A teacher wants students to submit one PDF instead of several images. What is the benefit?',
      options: [
        'PDF files keep related pages together in one document.',
        'PDF files always reduce content to one paragraph.',
        'PDF files cannot contain text formatting.',
        'PDF files prevent any printing or sharing.',
      ],
    ),
    (
      prompt:
          'Which setting helps reduce eye strain during long computer sessions?',
      options: [
        'Increase screen brightness to maximum at all times.',
        'Use appropriate zoom, text size, or display scaling.',
        'Disable all accessibility settings permanently.',
        'Place the monitor directly in front of a bright window.',
      ],
    ),
    (
      prompt: 'What is the best reason to use a table in a document?',
      options: [
        'To organize related information into rows and columns',
        'To block the document from spell check',
        'To hide citations from the reader',
        'To replace the need for page margins',
      ],
    ),
    (
      prompt:
          'A student wants to cite facts from a website in a report. Which action is most responsible?',
      options: [
        'Copy the text without checking the source.',
        'Confirm the source is credible and cite it properly.',
        'Remove the author name to save space.',
        'Paste only the first paragraph so citation is unnecessary.',
      ],
    ),
    (
      prompt: 'Which device is an example of output hardware?',
      options: ['Keyboard', 'Microphone', 'Monitor', 'Scanner'],
    ),
    (
      prompt: 'What is the best use of a spreadsheet filter?',
      options: [
        'To display only rows that match selected criteria',
        'To change every cell into the same color automatically',
        'To combine multiple worksheets into one sentence',
        'To convert a workbook into a video presentation',
      ],
    ),
    (
      prompt: 'Which practice helps keep shared cloud folders organized?',
      options: [
        'Use consistent folder names and avoid duplicates.',
        'Upload every version with the name New File.',
        'Move files without telling collaborators.',
        'Store unrelated files together in one folder.',
      ],
    ),
    (
      prompt:
          'A student accidentally deletes important text in a document. Which command is the fastest way to restore it?',
      options: ['Undo', 'Refresh', 'Download', 'Share'],
    ),
    (
      prompt: 'What is the safest way to connect to a public wireless network?',
      options: [
        'Share files openly so devices can discover each other.',
        'Use secure websites and avoid sensitive transactions when possible.',
        'Turn off the firewall because it slows the connection.',
        'Disable password prompts on the device.',
      ],
    ),
    (
      prompt:
          'Why might someone use comments instead of editing a teammate\'s presentation slide directly?',
      options: [
        'Comments allow discussion without changing the slide content yet.',
        'Comments automatically publish the slide online.',
        'Comments remove the need for teamwork.',
        'Comments prevent the slide from saving.',
      ],
    ),
    (
      prompt:
          'Which file extension is commonly associated with a spreadsheet workbook?',
      options: ['.xlsx', '.mp3', '.jpg', '.html'],
    ),
    (
      prompt: 'What is the purpose of a device backup?',
      options: [
        'To create a copy of important data for recovery',
        'To increase the screen resolution permanently',
        'To reduce the need for passwords',
        'To stop all apps from updating',
      ],
    ),
    (
      prompt: 'Which action best improves the readability of a slide deck?',
      options: [
        'Use concise text and strong visual contrast.',
        'Place long paragraphs on every slide.',
        'Use several unrelated fonts on the same slide.',
        'Fill empty space with decorative icons only.',
      ],
    ),
    (
      prompt:
          'A student sees a paperclip icon next to an email message. What does it usually mean?',
      options: [
        'The email is encrypted and cannot be read.',
        'The email includes an attachment.',
        'The message will be deleted automatically.',
        'The sender is currently online.',
      ],
    ),
    (
      prompt: 'Which online behavior best protects personal privacy?',
      options: [
        'Share birth date and address on every social profile.',
        'Review privacy settings before posting personal information.',
        'Accept every friend request from unknown users.',
        'Reuse the same public username and password everywhere.',
      ],
    ),
    (
      prompt:
          'What is the best reason to use slide notes during a presentation?',
      options: [
        'They help the presenter remember details without crowding slides.',
        'They make the slideshow impossible to edit.',
        'They replace the need for visual content.',
        'They lock the slideshow after it begins.',
      ],
    ),
    (
      prompt:
          'Which spreadsheet feature automatically recalculates totals when source values change?',
      options: ['Formulas', 'Headers', 'Margins', 'Comments'],
    ),
    (
      prompt:
          'A user wants to share a large folder with a project team. Which option is usually most efficient?',
      options: [
        'Send each file in a separate email.',
        'Use a shared cloud folder with defined permissions.',
        'Print all files and scan them back as images.',
        'Rename the folder every day so members notice changes.',
      ],
    ),
    (
      prompt:
          'Which action is appropriate before recycling or donating an old computer?',
      options: [
        'Leave personal files on the drive for the next user.',
        'Back up needed data and remove personal information.',
        'Disable the monitor and keep the storage unchanged.',
        'Copy the files to the desktop and power off the device.',
      ],
    ),
    (
      prompt: 'What is the best description of two-factor authentication?',
      options: [
        'Signing in with two usernames at once',
        'Using two devices to open the same file',
        'Verifying identity with a password plus another proof',
        'Saving two copies of the same password',
      ],
    ),
    (
      prompt:
          'Why should a presenter preview a slideshow before delivering it?',
      options: [
        'To confirm layout, timing, and links appear correctly',
        'To hide the title slide from the audience',
        'To remove speaker notes from all slides permanently',
        'To prevent the slideshow from being saved',
      ],
    ),
    (
      prompt: 'Which action makes it easier to locate a file later?',
      options: [
        'Using a descriptive file name and consistent folder structure',
        'Saving every file as Untitled',
        'Moving files to different folders every week',
        'Relying only on recent files history forever',
      ],
    ),
    (
      prompt:
          'A team needs to collect responses from many participants online. Which tool is most suitable?',
      options: [
        'A form or survey tool that stores responses automatically',
        'A paint application with brush presets',
        'A media player with playlists',
        'A calculator with memory buttons',
      ],
    ),
    (
      prompt: 'What is the clearest reason to cite sources in digital work?',
      options: [
        'To hide where ideas came from',
        'To give credit and support the accuracy of information',
        'To make the file size smaller',
        'To remove the need for editing',
      ],
    ),
  ];

  final baseQuestions = seeds.take(31).toList();

  return [
    for (var i = 0; i < baseQuestions.length; i++)
      ExamQuestion(
        number: i + 1,
        prompt: baseQuestions[i].prompt,
        options: baseQuestions[i].options,
      ),
    ..._buildScreenshotQuestions(startNumber: baseQuestions.length + 1),
  ];
}

List<ExamQuestion> _buildScreenshotQuestions({required int startNumber}) {
  var number = startNumber;

  return [
    ExamQuestion(
      number: number++,
      prompt:
          'You are searching the internet for facts and information to use for a research project, but your results are not giving you the answers you expected.',
      promptDetails: const ['Which action should you take?'],
      options: const [
        'Refresh the page and search again.',
        'Rephrase your search term to be more specific.',
        'Clear your browser\'s cache and search again.',
        'Use fewer words in your search term.',
      ],
    ),
    ExamQuestion(
      number: number++,
      prompt:
          'What is the purpose of clearing file storage space during troubleshooting?',
      options: const [
        'To make room for new system updates',
        'To increase network speed',
        'To remove viruses from the system',
        'To prevent applications from syncing with cloud storage',
      ],
    ),
    ExamQuestion(
      number: number++,
      type: ExamQuestionType.matching,
      prompt:
          'Match each media creation process from the list on the left with its appropriate action on the right.',
      promptDetails: const [
        'Note: You will receive partial credit for each correct answer.',
      ],
      sourceItems: const [
        'Capture video',
        'Finalize production',
        'Distribute video',
      ],
      targetItems: const [
        'Adjusting colors, contrast, and brightness of the footage',
        'Choosing the right video resolution and aspect ratio for the platform',
        'Uploading the video to YouTube or other platforms for audience access',
      ],
    ),
    ExamQuestion(
      number: number++,
      type: ExamQuestionType.ordering,
      prompt:
          'You need to plan a project that will use a cyclical design process. In which order should you complete the project tasks?',
      promptDetails: const [
        'Move all the actions to the answer area and place them in the correct order.',
      ],
      sourceItems: const [
        'Develop the prototype',
        'Identify project requirements',
        'Generate ideas',
        'Test the prototype',
        'Refine the prototype',
      ],
    ),
    ExamQuestion(
      number: number++,
      type: ExamQuestionType.multipleChoice,
      prompt:
          'You lead a project team in your digital design class. You and your teammates will create a project for a local business. You arrange a virtual meeting with the business owner to discuss the project.',
      promptDetails: const [
        'You need to ensure that the business owner leaves the meeting with confidence that your team can successfully complete the project.',
        'Which three actions should you take? (Choose 3.)',
        'Note: You will receive partial credit for each correct answer.',
      ],
      requiredSelections: 3,
      options: const [
        'After the client presents ideas, paraphrase what they said.',
        'Tell the client that you will email a draft proposal that includes deadlines.',
        'Include a lengthy discussion about the design applications you will use.',
        'Decide with the client which forms of digital communication to use during the project.',
        'Speak in a casual, informal manner to put the client at ease and encourage discussion.',
        'Discuss your career goals in the field of digital design.',
      ],
    ),
    ExamQuestion(
      number: number++,
      prompt:
          'You are trying to access a website, but it is not loading properly on your browser.',
      promptDetails: const ['What should you try first?'],
      options: const [
        'Email the website owner',
        'Remove unnecessary apps',
        'Clear the browser cache',
        'Check the BIOS settings',
      ],
    ),
    ExamQuestion(
      number: number++,
      type: ExamQuestionType.multipleChoice,
      prompt:
          'Which two actions describe ways to protect individual and corporate intellectual property? (Choose 2.)',
      requiredSelections: 2,
      options: const [
        'Create a Creative Commons license, allowing others to use your work with attribution.',
        'Create a digital portfolio that is accessible to everyone on the internet.',
        'Share your creative work on a public social media account.',
        'Embed your name in the metadata of digital files as the copyright owner.',
      ],
    ),
    ExamQuestion(
      number: number++,
      prompt:
          'You are using Microsoft Word on a Windows 10 computer to write a paper about a company. The company name, ABusiness, begins with two capital letters. Each time you type the company name, the software corrects the capital letters.',
      promptDetails: const ['Where can you change this correction preference?'],
      options: const [
        'In the computer operating system preferences',
        'In the Office Language Preferences',
        'In the AutoCorrect Options settings',
        'In the Grammar & Refinements settings',
      ],
    ),
    ExamQuestion(
      number: number++,
      prompt:
          'You purchase a software program to complete a specific project. After you finish the project, a friend asks to borrow the program.',
      promptDetails: const [
        'You need to determine whether this is an acceptable use of the software.',
        'Where can you find this information?',
      ],
      options: const [
        'Access Control List (ACL)',
        'End User License Agreement (EULA)',
        'Electronic Software Rating Board (ESRB)',
        'Content Management System (CMS)',
      ],
    ),
    ExamQuestion(
      number: number++,
      type: ExamQuestionType.matrix,
      prompt:
          'You encounter a video on social media that you suspect might be a deepfake generated by AI.',
      promptDetails: const [
        'For each statement, select Yes if the action would help you determine if the video is fake or No if it would not.',
      ],
      matrixColumns: const ['Yes', 'No'],
      matrixRows: const [
        'Assume that because the video contains a statement unlikely to be said by the speaker that the video is trustworthy',
        'Search online for some of the specific quotes from the video to see if they are being featured by reputable news organizations.',
        'Consider the motivations of the originators and sharers of the video.',
        'Check the comments on the video to see if there are accusations of impropriety or other issues',
      ],
    ),
    ExamQuestion(
      number: number++,
      type: ExamQuestionType.multipleChoice,
      prompt:
          'You design a website for your school to track student involvement in clubs. You arrange a usability test to find out how well students can use the website.',
      promptDetails: const [
        'Which two actions should you take to ensure you get good test data? (Choose 2.)',
      ],
      requiredSelections: 2,
      options: const [
        'Listen to the students and record any questions they have about how to use the site.',
        'Show the students how to use the website.',
        'Tell the students why the school asked you to create the website.',
        'Watch the students use the website and note whether they have problems.',
      ],
    ),
    ExamQuestion(
      number: number++,
      prompt:
          'McKenna is setting up a new social media account and is asked to enable multifactor authentication.',
      promptDetails: const [
        'What is the main purpose of enabling this feature?',
      ],
      options: const [
        'To confirm your identity',
        'To create a more complex password for your account',
        'To change your password every month',
        'To allow your friends to easily find you online',
      ],
    ),
    ExamQuestion(
      number: number++,
      type: ExamQuestionType.matrix,
      prompt:
          'For each statement about digital communications with clients and coworkers, select True or False',
      matrixColumns: const ['True', 'False'],
      matrixRows: const [
        'Avoid directly stating the purpose of the message.',
        'Use bullet points or lists to organize message details.',
        'Use acronyms and abbreviations in all messages to keep them brief.',
        'When you need a client to make a choice, provide multiple options to minimize back-and-forth.',
      ],
    ),
    ExamQuestion(
      number: number++,
      prompt:
          'Your team has just completed a client review, and the client is not happy with the product. They have requested multiple changes to the product to address the problems, and they need the product to be fixed as quickly as possible.',
      promptDetails: const [
        'How should you efficiently complete their revisions?',
      ],
      options: const [
        'Assign all work to the most experienced team member so the rest of the team can work on other projects.',
        'Assign responsibilities so work is evenly distributed among team members.',
        'Assign all tasks to the entire team so everyone will collaborate on the remaining tasks.',
        'Assign the same task to multiple team members to avoid missing any of the remaining tasks.',
      ],
    ),
  ];
}
