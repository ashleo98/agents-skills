## Description:

Helps users discover and install agent skills when they are looking for installable functionality to extend agent capabilities.

This skill is ready for commercial/non-commercial use.

## Publisher:

[eohmig](https://clawhub.ai/user/eohmig)

### License/Terms of Use:

MIT-0

## Use Case:

Developers and agent users use this skill to find, evaluate, and install relevant skills from the open agent skills ecosystem when a task may be better handled by an existing skill.

### Deployment Geography for Use:

Global

## Known Risks and Mitigations:

Risk: The skill can lead an agent to run a dynamically resolved CLI and install third-party skills globally without interactive confirmation.

Mitigation: Require explicit approval before installs, prefer pinned CLI versions, and use local or scoped installs where possible.

## Reference(s):

- [find-skills ClawHub skill page](https://clawhub.ai/eohmig/skills/find-skills)
- [skills.sh skill catalog](https://skills.sh/)

## Skill Output:

**Output Type(s):** [Guidance, Shell commands]

**Output Format:** [Markdown with inline shell commands]

**Output Parameters:** [1D]

**Other Properties Related to Output:** [May include skill names, install counts, source reputation notes, install commands, and links to skills.sh.]

## Skill Version(s):

1.0.0 (source: server release metadata)

## Ethical Considerations:

Users should evaluate whether this skill is appropriate for their environment, review any generated or modified files before relying on them, and apply their organization's safety, security, and compliance requirements before deployment.
