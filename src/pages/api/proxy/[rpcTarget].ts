export const prerender = false;

import { decodeIdToken } from "../../../modules/cognito";
import type { tokenProps } from "../../../modules/cognito";

import * as jose from 'jose' 

export async function POST(request) {
    let userIdData: tokenProps;

    const headers = new Headers(request.request.headers);
    const cookies = headers.get('cookie');
    if (cookies) {
        for (const cookie of cookies.split(';')) {
            if (cookie.split('=')[0] === 'access-token') {
                const awsIdToken = cookie.split('=')[1];
                try{
                    userIdData = await decodeIdToken(import.meta.env, awsIdToken);
                } catch (e) {
                    return new Response(null, { 
                        status: 401,
                        statusText: 'Invalid Token.'
                    })
                }
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
    }
    // Both Supabase and local server have the same JWT secret for bike_user.
    if (userIdData?.email) {

        const secret = new TextEncoder().encode(import.meta.env.SERVER_DB_SECRET,)
        const alg = 'HS256'
        const jwt = await new jose.SignJWT({
            'role': 'bike_user',
            'email' : userIdData.email
        })
        .setProtectedHeader({ alg })
        .setIssuedAt()
        .setExpirationTime('1h')
        .sign(secret)
          
        // console.log(jwt)
        dbHeaders.append('Authorization',`Bearer ${jwt}`);
    } 
    console.log(jsonBody);
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