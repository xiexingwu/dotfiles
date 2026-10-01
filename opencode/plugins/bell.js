// Ring the terminal bell when opencode needs attention, so zellij/zjstatus can flag the tab.
import { closeSync, openSync, writeSync } from "node:fs"

const bell = () => {
  try {
    const fd = openSync("/dev/tty", "w")
    writeSync(fd, "\x07")
    closeSync(fd)
  } catch {}
}

export const Bell = async ({ client }) => ({
  event: async ({ event }) => {
    if (event.type === "permission.asked" || event.type === "question.asked") return bell()
    if (event.type !== "session.idle") return
    try {
      const res = await client.session.get({ path: { id: event.properties.sessionID } })
      if (res.data?.parentID) return // a subagent finished; the main session is still working
    } catch {}
    bell()
  },
})
