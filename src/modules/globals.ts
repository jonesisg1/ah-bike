let globals = {};

export function getGlobal (name: string) {
    return globals[name];
}

export function setGlobal (name: string, value: any) {
    globals[name] = value;
}