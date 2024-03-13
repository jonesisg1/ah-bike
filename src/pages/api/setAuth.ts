export const prerender = false;
import { decodeIdToken } from "../../modules/cognito";

export async function GET({params, request}) {
    const url = new URL(request.url);
    const params1 = new URLSearchParams(url.search);
    const awsIdToken = params1.get('id_token');
    try {
        const creds = await decodeIdToken(import.meta.env, awsIdToken);
        let headers = new Headers()
        headers.append('Set-Cookie', `access-token=${awsIdToken}; HttpOnly`);
        // headers.append('Set-Cookie', 'ah-sign-in=untrusted;'); Can't get to work :(
        console.log(headers)
        return new Response(
            JSON.stringify(creds),
            {status: 200, headers: headers}
        );
    } catch (e) {
        console.error(e);
        return new Response( JSON.stringify({error:'Could not decode JWT.'}), {status: 401} );
    }
}