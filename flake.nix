{
  description = "Claude Code as an agent stack: the harness, two plugins, and the runtimes they need";

  inputs.agent-pkgs.url = "github:agent-stacks/agent-pkgs";

  outputs = { self, agent-pkgs }: {
    # One stack per system agent-pkgs builds for. It is the default package,
    # so `nix run github:agent-stacks/claude-code` needs no attribute:
    # mkAgentStack names the launcher after the stack and sets it as the main
    # program, which is what `nix run` executes.
    packages = builtins.mapAttrs
      (system: pkgs: {
        default = agent-pkgs.lib.${system}.mkAgentStack {
          name = "claude-code";
          harness = pkgs.claude-code;
          plugins = [
            pkgs.agent-plugin-caveman
            pkgs.agent-plugin-agentmemory
          ];
        };
      })
      agent-pkgs.packages;
  };
}
