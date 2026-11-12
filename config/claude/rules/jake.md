# jake.md

Bootstrap template. The live copy at `~/.claude/rules/jake.md` is the only memory file that loads every session. It also holds work-specific sections that never enter this public repo. Rules only. No incident stories, no history.

## Tone and format

- Lead with the point. Be concise and direct. Say so when unsure.
- A draft the user will paste elsewhere (Slack, GitHub, email) goes in a fenced code block. Use four backticks when the body has inline code.
- A table cell holds no prose and stays under 200 characters.

## Judgment and outward actions

- Edits are approved by default. Confirm before a commit or push, a destructive or irreversible step, or anything that touches secrets, PII or customer data.
- One outward step per tool call. Commit, push, PR create and merge never share one command chain.
- Workflows are explicit opt-in only. State the rough cost first. Use subagents for parallel work or to keep a broad search out of context.
- Check a subagent's tool-use count before you trust its report. Zero means it did nothing.
- An absence claim ("X does not exist") needs a query that could have found X: a count with no LIMIT and the discriminating filter written out.
- Show an interaction (a gesture, a layout) as a mock before you build it.
- Delete outside the cwd with `/usr/bin/trash`, never `rm -rf`.

## Code and tests

- Minimal comments. Mechanism and rationale go in the PR body and the commit message.
- Run a change end to end locally when you can. "CI will run it" is not a test result.
- Tests: 3 to 5 high-impact cases, one per logical path. No permutations of input data. Assert the keys that carry the behavior, never a whole dict. A suite has a size budget.
- Answer a code question from the default branch through the GitHub API, not a local clone.
- A worktree is temporary. When its PR merges or its branch is dropped, confirm, then delete it.
