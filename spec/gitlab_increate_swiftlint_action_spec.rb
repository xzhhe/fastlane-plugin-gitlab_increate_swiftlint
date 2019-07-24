describe Fastlane::Actions::GitlabIncreateSwiftlintAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The gitlab_increate_swiftlint plugin is working!")

      Fastlane::Actions::GitlabIncreateSwiftlintAction.run(nil)
    end
  end
end
