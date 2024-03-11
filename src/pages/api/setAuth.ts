export const prerender = false;
import { decodeIdToken } from "../../modules/cognito";
export async function GET({params, request}) {
    const url = new URL(request.url);
    const params1 = new URLSearchParams(url.search);
    const awsIdToken = params1.get('id_token');
    const creds = await decodeIdToken(import.meta.env, awsIdToken);
    console.log(creds)
    
// let creds
      return new Response(
        JSON.stringify(creds),
        {status: 200, headers:{
            "Set-Cookie": `access-token=${awsIdToken}; HttpOnly` 
        }}
      )
}