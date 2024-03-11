export const prerender = false;

import { getCognitoSignInUrl, getCognitoSignOutUrl, decodeIdToken } from "../../modules/cognito";

export async function GET({params, request}) {
    const headers = new Headers(request.headers)
    const url = new URL(request.url);
    const params1 = new URLSearchParams(url.search);
    const callback = params1.get('callback');
    // defaults, override if we find cookie
    let cognitoUrl = getCognitoSignInUrl(import.meta.env, callback + '/signIn');
    let linkText = 'Staff Login';
    let icon = 'box-arrow-in-right';       
               
    for (const [key, value] of headers.entries()) {   
        console.info(`${key} ==> ${value}`)     
        if (key == 'cookie') {
            // we might have multiple access tokens
            for (const cookie of value.split(';')) {
                if (cookie.split('=')[0] === 'access-token') {
                    const awsIdToken = cookie.split('=')[1];
                    const creds = await decodeIdToken(import.meta.env, awsIdToken);
                    cognitoUrl = getCognitoSignOutUrl(import.meta.env, callback) + '/signOut';
                    linkText = `Sign Out ${creds.email}`;
                    icon = 'box-arrow-left';
                }
            }
        }   
    }
    const html = `<sl-icon name="${icon}" style="margin-bottom: -2px;"></sl-icon>
                  <a id="login" class="no-underline hover:underline" href="${cognitoUrl}">${linkText}</a>`;

    return new Response(html);
}