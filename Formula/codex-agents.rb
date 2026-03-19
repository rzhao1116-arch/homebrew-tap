class CodexAgents < Formula
  desc "Codex agent bundle with orchestrator routing skill and lifecycle CLI"
  homepage "https://github.com/rzhao1116-arch/codex-agents"
  url "https://github.com/rzhao1116-arch/codex-agents/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "f20e745553541502eec0063edf9d99a75f3c24111cee346900fad1958ee9e72f"
  license "MIT"

  depends_on "python@3.13"

  def install
    libexec.install "agents", "skills", "bin", "LICENSE", "README.md"
    bin.write_exec_script libexec/"bin/codex-agents"
  end

  test do
    assert_match "Bundled agents:", shell_output("#{bin}/codex-agents list")
    assert_match "Bundled skills:", shell_output("#{bin}/codex-agents list")

    target = testpath/"codex-home"
    system bin/"codex-agents", "install", "--target", target.to_s

    doctor_json = shell_output("#{bin}/codex-agents doctor --target #{target} --json")
    assert_match "\"orchestrator_routing_skill\": {", doctor_json
    assert_match "\"present\": true", doctor_json
    assert_path_exists target/"agents/orchestrator.toml"
    assert_path_exists target/"skills/orchestrator-routing/SKILL.md"
  end
end
