enum PortalFlowStep {
  login,
  address,
  readiness,
  examSelect,
  nda,
  verifyUnlock,
  systemCheck,
  preExamLanding,
  scoreSummary,
  fullScoreReport,
}

const Map<String, String> portalLanguages = {
  'English': 'English',
  'Uzbek': 'Uzbek',
  'Russian': 'Russian',
};

const Map<String, String> portalPrograms = {
  'All programs': 'All programs',
  'IC3 Digital Literacy': 'IC3 Digital Literacy',
  'Microsoft Office Specialist': 'Microsoft Office Specialist',
};

const Map<String, String> portalAssignedVouchers = {
  'IC3G-2026-DEMO-7821': 'IC3G-2026-DEMO-7821',
  'IC3G-2026-DEMO-9144': 'IC3G-2026-DEMO-9144',
};
