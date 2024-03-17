import type { SLElement } from "./types";


// Always escape HTML for text arguments!
const escapeHtml = (html) => {
    const div = document.createElement('div');
    div.textContent = html;
    return div.innerHTML;
}

// Custom function to emit toast notifications
export async function notifyAsToast(heading: string, message: string, variant = 'primary', icon = 'info-circle', duration = 3000) {
    const alert: SLElement = Object.assign(document.createElement('sl-alert'), {
        variant,
        closable: true,
        duration: duration,
        innerHTML: `
            <sl-icon name="${icon}" slot="icon"></sl-icon>
            <strong>${escapeHtml(heading)}</strong><br/>
            ${escapeHtml(message)}
        `
    });
    console.log(alert);
    document.body.append(alert);
    await customElements.whenDefined('sl-alert');
    return alert.toast();
}


