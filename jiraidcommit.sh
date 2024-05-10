To add a JIRA ID to a commit message in Git, you can follow these steps:

Create a branch with the JIRA ID: When creating a new branch, include the JIRA ID in the branch name. This will help in automatically adding the JIRA ID to the commit message later1.
Prepare a commit message hook: Git allows you to add a prepare-commit-msg hook in your local repository. This hook is invoked by git commit, and can be bypassed with the --no-verify option. It takes one to three parameters1:
The name of the file that contains the commit log message.
The type of commit. The possible values are message, template, merge, squash, or commit.
The commit SHA-1, when a commit is amended1.
Add logic to the hook: You can add logic to this hook to automatically add the JIRA ID to the commit message. Here is an example of how you can do this1:
Ruby

#!/usr/bin/env ruby

message_filename = ARGV[0]
message = File.read(message_filename)

jira_pattern = /^([A-Z]{1,32}-[0-9]{1,32})\\s/
jira_id = message[jira_pattern, 1]

if jira_id.nil?
  current_branch_name = `git rev-parse --abbrev-ref HEAD`
  exit if current_branch_name[/^(master|develop|release|hotfix)/]
  jira_branch_pattern = /^([a-zA-Z]{1,32}-[0-9]{1,32})[-_\\/]?/
  jira_branch_id = current_branch_name[jira_branch_pattern, 1]

  if jira_branch_id.nil? || jira_branch_id.empty?
    raise "Commit message missing JIRA ID and/or branch name does not have one"
  else
    jira_url = "https://jira.yourcompany.com/browse/#{jira_branch_id}"
    new_message = "#{jira_branch_id.upcase} - #{message}\n#{jira_url}\n"
    File.open(message_filename, 'w') {|file| file.puts new_message}
  end
end
AI-generated code. Review and use carefully. More info on FAQ.
This script will automatically add the JIRA ID from the branch name to the commit message. If the branch name does not contain a JIRA ID, the commit will be aborted with an error1.

Remember to replace https://jira.yourcompany.com/browse/ with the actual URL of your JIRA instance1.

I hope this helps! Let me know if you have any other questions.
