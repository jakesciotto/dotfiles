# Claude Code OTLP endpoint. Since 2.1.282 project and local settings ignore
# it, so the shell owns it. .zshenv, not .zshrc: zsh reads it for a non-login
# ssh shell and a script too. host.name stays in ~/.claude/settings.local.json.
export OTEL_EXPORTER_OTLP_ENDPOINT=http://vinelab:4317
