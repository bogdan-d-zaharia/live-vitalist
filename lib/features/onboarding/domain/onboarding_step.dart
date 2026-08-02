enum OnboardingStep {
  complexity("How much detail do you want to have?"),
  streak("Do you like having a streak?"),
  ;

  final String question;
  const OnboardingStep(this.question);
}
