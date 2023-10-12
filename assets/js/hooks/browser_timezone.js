/*
 * Use JS in the browser to detect the user's timezone and send that to the
 * server.
 *
 */
export const hooks = {
  BrowserTimezone: {
    mounted() {
      let tz = Intl.DateTimeFormat().resolvedOptions().timeZone
      this.pushEvent("browser-timezone", {timezone: tz})
    }
  }
}
