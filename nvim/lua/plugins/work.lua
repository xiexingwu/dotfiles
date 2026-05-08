return {
  "letieu/jira.nvim",
  opts = {
    -- Your setup options...
    jira = {
      limit = 200, -- Global limit of tasks per view (default: 200)
    },
  },

  active_sprint_query = "project = DNA AND sprint in openSprints() ORDER BY Rank ASC",
  queries = {
    ["Next sprint"] = "project = '%s' AND sprint in futureSprints() ORDER BY Rank ASC",
    ["Backlog"] =
    "project = '%s' AND (issuetype IN standardIssueTypes() OR issuetype = Sub-task) AND (sprint IS EMPTY OR sprint NOT IN openSprints()) AND statusCategory != Done ORDER BY Rank ASC",
    ["My Tasks"] = "assignee = currentUser() AND statusCategory != Done ORDER BY updated DESC",
  },

  projects = {
    ["DNA"] = {
      story_point_field = "customfield_10035", -- Custom field ID for story points
      -- custom_fields = { -- Custom field to display in markdown view
      --   { key = "customfield_10016", label = "Acceptance Criteria" }
      -- },
    }
  }
}
