export interface HTMXEvent extends Event {
    detail: any;
}

export interface HTMXEventTarget extends EventTarget {
    dataset: any;
    value: any;
}

export interface SLElement extends Element {
    dataset?: any;
    show?(): any;
    hide?(): any;
    toast?(): any;
}