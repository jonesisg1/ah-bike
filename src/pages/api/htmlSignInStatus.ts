export const prerender = false;

import { getCognitoSignInUrl, getCognitoSignOutUrl, decodeIdToken } from "../../modules/cognito";

export async function GET({params, request}) {
    const headers = new Headers(request.headers)
    const cookie = headers.get('cookie');
    const url = new URL(request.url);
    const params1 = new URLSearchParams(url.search);
    const callback = params1.get('callback');
    let cognitoUrl = '';
    let linkText = 'Staff Login';
    let icon = 'box-arrow-in-right';

    if (cookie) {
        if (cookie.split('=')) {
            if (cookie.split('=')[0] === 'access-token') {

                const awsIdToken = cookie.split('=')[1];
                const creds = await decodeIdToken(import.meta.env, awsIdToken);

                cognitoUrl = getCognitoSignOutUrl(import.meta.env, callback) + '/signOut';
                linkText = `Sign Out ${creds.email}`;
                icon = 'box-arrow-left'
            }
        }
    } else {
        cognitoUrl = getCognitoSignInUrl(import.meta.env, callback + '/signIn');
    }

    const html = `<sl-icon name="${icon}" style="margin-bottom: -2px;"></sl-icon>
                  <a id="login" class="no-underline hover:underline" href="${cognitoUrl}">${linkText}</a>`;

    return new Response(
        html
    )
}