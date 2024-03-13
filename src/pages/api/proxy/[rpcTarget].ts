export const prerender = false;

import { decodeIdToken } from "../../../modules/cognito";
import type { tokenProps } from "../../../modules/cognito";

export async function POST(request) {
    let userIdData: tokenProps;

    const headers = new Headers(request.request.headers);
    const cookies = headers.get('cookie');
    if (cookies) {
        for (const cookie of cookies.split(';')) {
            if (cookie.split('=')[0] === 'access-token') {
                const awsIdToken = cookie.split('=')[1];
                userIdData = await decodeIdToken(import.meta.env, awsIdToken);
            }
        }
    }

    const bikeApi = import.meta.env.SERVER_BIKE_API;
    let url = new URL(request.url);
    let urlStr = url.toString()
                .replace(url.protocol+'//'+url.host,bikeApi)
                .replace('/api/proxy/', '/rpc/');
    
    const jsonBody = JSON.stringify(Object.fromEntries(await request.request.formData()));
    
    const dbHeaders = new Headers();
    dbHeaders.append('Content-Type','application/json');
    dbHeaders.append('Accept','text/html');
    
    if (bikeApi.includes('supabase')) {
        dbHeaders.append('Content-Profile','bikes_api');
        dbHeaders.append('apikey', import.meta.env.PUBLIC_ANON_KEY);
        dbHeaders.append('Authorization','Bearer ' + import.meta.env.PUBLIC_ANON_KEY);
    } else    
    if (userIdData?.email) {
        dbHeaders.append('Authorization',`Bearer ${import.meta.env.SERVER_DB_JWT}`)
    }
    const dbResponse = await fetch(urlStr, {
        method: "POST",
        headers: dbHeaders,
        body: jsonBody,
      });

    return new Response(
        await dbResponse.text(),{
            status: 200,
            headers: {
              "Content-Type": "text/html"
            }
          }
    )
}