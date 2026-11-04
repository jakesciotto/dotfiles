# Claude Code OTel exports. Since 2.1.282 project and local settings ignore
# the endpoint, and since 2.1.286 they also drop OTEL_RESOURCE_ATTRIBUTES, so
# the shell owns both. .zshenv, not .zshrc: zsh reads it for a non-login ssh
# shell and a script too. The box name still lives in settings.local.json
# (hostnames are DHCP-unreliable on the Macs); .zshrc reads it the same way.
export OTEL_EXPORTER_OTLP_ENDPOINT=http://vinelab:4317
_box=$(sed -n 's/.*host\.name=\([^",]*\).*/\1/p' ~/.claude/settings.local.json 2>/dev/null | head -1)
[[ -n $_box ]] && export OTEL_RESOURCE_ATTRIBUTES="host.name=$_box"
unset _box
