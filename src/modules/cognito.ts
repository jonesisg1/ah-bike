import { CognitoJwtVerifier } from "aws-jwt-verify";

export type tokenProps = {
    email: string;
    nickName: string;
}

export function getIdTokenFromHash (hash: string): string {
    return hash.substring(1).split('&').find((element)=> element.split('=')[0]='id_token')?.split('=')[1] || '';
}

export function getCognitoSignInUrl (env, callback: string): string {
    const url = `${env.PUBLIC_COGNITO_USER_POOL_DOMAIN}/login?response_type=token&client_id=${env.PUBLIC_COGNITO_APP_CLIENT_ID}&redirect_uri=${callback}`;
    // console.log(url); 
    return url;
}

export function getCognitoSignOutUrl (env, callback: string): string {
    return `${env.PUBLIC_COGNITO_USER_POOL_DOMAIN}/logout?client_id=${env.PUBLIC_COGNITO_APP_CLIENT_ID}&logout_uri=${callback}`;
}

export async function decodeIdToken(env, token: string): Promise<tokenProps> { 
    // Verifier that expects valid access tokens:
    // console.log(`pool=${env.PUBLIC_COGNITO_USER_POOL_ID} client=${env.PUBLIC_COGNITO_APP_CLIENT_ID} token=${token}`)
    const verifier = CognitoJwtVerifier.create({
        userPoolId: env.PUBLIC_COGNITO_USER_POOL_ID,
        tokenUse: "id",
        clientId: env.PUBLIC_COGNITO_APP_CLIENT_ID
      });
    let tokenProps: tokenProps;
    try {
        const payload = await verifier.verify(token);
        tokenProps = <tokenProps>({
            email: payload.email?.toString(),
            nickName: payload.nickname?.toString()
        });
    } catch (err) {
        console.log(err);
        throw err;
    }
    return tokenProps;
}