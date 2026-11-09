/// Text scale factors that every page should render cleanly at.
///
/// iOS Dynamic Type ranges from "Large" (the default, 1.0x) up to the largest
/// accessibility size (AX5), whose body text is roughly 3.1x the default.
const Map<String, double> textScalesUnderTest = {
  'default': 1,
  'extra large': 1.35,
  'accessibility medium': 2,
  'accessibility max (AX5)': 3.12,
};
