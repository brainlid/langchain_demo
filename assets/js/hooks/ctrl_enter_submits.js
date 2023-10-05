/*
 * Catch a Ctrl+Enter keypress and trigger the form to submit.
 *
 */
export const hooks = {
  CtrlEnterSubmits: {
    mounted() {
      this.el.addEventListener("keydown", (e) => {
        if (e.ctrlKey && e.key === 'Enter') {
          let form = e.target.closest('form');
          form.dispatchEvent(new Event('submit', {bubbles: true}));
          e.stopPropagation();
          e.preventDefault();
        }
      })
    }
  }
}
