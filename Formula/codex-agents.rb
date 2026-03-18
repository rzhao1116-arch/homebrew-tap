class CodexAgents < Formula
  desc "Codex agent bundle with orchestrator routing skill and lifecycle CLI"
  homepage "https://github.com/rzhao1116-arch/codex-agents"
  url "https://github.com/rzhao1116-arch/codex-agents/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "338fec4c56d93ea39b0c14bdf86769287562c348a0f52b5f8c7f6eeb57059bbc"
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
    assert_path_exists target/"agents/orchestrator.md"
    assert_path_exists target/"skills/orchestrator-routing/SKILL.md"
  end
end
