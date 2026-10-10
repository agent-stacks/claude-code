# claude-code

Claude Code as an [agent stack](https://agent-stacks.org): the harness,
two plugins, and the runtimes those plugins need, built as one package
that runs the same on every machine.

It is the reference stack for [agent-stacks.org](https://agent-stacks.org),
and a starting point for your own.

## Run it

```sh
nix run github:agent-stacks/claude-code
```

You need [Nix](https://nixos.org/download/) with flakes enabled. If you
see `experimental Nix feature 'nix-command' is disabled`, the
[agent-pkgs README](https://github.com/agent-stacks/agent-pkgs#prerequisites)
shows how to turn them on. You do not need Claude Code installed.

Claude Code starts with both plugins loaded. Type `/caveman:` at the
prompt to see the caveman skills.

Anything after `--` goes to Claude Code:

```sh
nix run github:agent-stacks/claude-code -- --version
nix run github:agent-stacks/claude-code -- plugin list
```

Your own `claude`, if you have one, is untouched. The plugins are added
for the session the stack launches and nowhere else.

## What is in it

| Part    | Package                                                   |
| ------- | --------------------------------------------------------- |
| Harness | Claude Code                                               |
| Plugin  | [caveman](https://github.com/juliusbrussee/caveman)       |
| Plugin  | [agentmemory](https://github.com/rohitg00/agentmemory)    |

The build puts one directory in the Nix store:

```text
agent-stack-claude-code/
├── bin/claude-code       # the launcher for the stack
└── share/agent-plugins/
    ├── caveman/          # plugin
    │   ├── plugin.json
    │   ├── skills/caveman-compress/scripts/compress.py
    │   └── bin/python3   # the runtime for compress.py
    └── agentmemory/      # plugin
        ├── plugin.json
        ├── mcp.json
        ├── skills/
        └── bin/npx       # the runtime for mcp.json's command
```

The versions are whatever `flake.lock` pins. To see the harness version
without building anything:

```sh
nix eval --raw github:agent-stacks/claude-code#default.passthru.agentStack.harness.name
```

## Update it

The stack stays on the versions it was locked to until someone moves
it. Both the harness and the plugins come from
[agent-pkgs](https://github.com/agent-stacks/agent-pkgs), so updating
that one input moves all of them:

```sh
nix flake update agent-pkgs
nix build
./result/bin/claude-code --version
git commit -m "update agent-pkgs" flake.lock
```

## Make your own

The whole stack is the `mkAgentStack` call in [`flake.nix`](flake.nix).
Fork this repository and change the plugin list, or follow
[Create an agent-stack package](https://github.com/agent-stacks/agent-pkgs/blob/main/docs/guides/create-agent-stack.md)
to write one from scratch.

## License

MIT. Claude Code and the packaged plugins carry their own licenses.
