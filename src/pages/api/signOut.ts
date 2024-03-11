export const prerender = false;
export async function GET({params, request}) {
      return new Response(
        JSON.stringify('{"signOut":"true"}'),
        {status: 200, headers:{
            "Set-Cookie": `access-token=; HttpOnly; max-age=0` 
        }}
    )
}