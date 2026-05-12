if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    hours?: string;
    minutes?: string;
    seconds?: string;
    isRunning?: boolean;
    timeLeft?: number;
    timerId?: number;
}
import promptAction from "@ohos:promptAction";
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__hours = new ObservedPropertySimplePU('0', this, "hours");
        this.__minutes = new ObservedPropertySimplePU('0', this, "minutes");
        this.__seconds = new ObservedPropertySimplePU('0', this, "seconds");
        this.__isRunning = new ObservedPropertySimplePU(false, this, "isRunning");
        this.__timeLeft = new ObservedPropertySimplePU(0, this, "timeLeft");
        this.timerId = -1;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.hours !== undefined) {
            this.hours = params.hours;
        }
        if (params.minutes !== undefined) {
            this.minutes = params.minutes;
        }
        if (params.seconds !== undefined) {
            this.seconds = params.seconds;
        }
        if (params.isRunning !== undefined) {
            this.isRunning = params.isRunning;
        }
        if (params.timeLeft !== undefined) {
            this.timeLeft = params.timeLeft;
        }
        if (params.timerId !== undefined) {
            this.timerId = params.timerId;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__hours.purgeDependencyOnElmtId(rmElmtId);
        this.__minutes.purgeDependencyOnElmtId(rmElmtId);
        this.__seconds.purgeDependencyOnElmtId(rmElmtId);
        this.__isRunning.purgeDependencyOnElmtId(rmElmtId);
        this.__timeLeft.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__hours.aboutToBeDeleted();
        this.__minutes.aboutToBeDeleted();
        this.__seconds.aboutToBeDeleted();
        this.__isRunning.aboutToBeDeleted();
        this.__timeLeft.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __hours: ObservedPropertySimplePU<string>;
    get hours() {
        return this.__hours.get();
    }
    set hours(newValue: string) {
        this.__hours.set(newValue);
    }
    private __minutes: ObservedPropertySimplePU<string>;
    get minutes() {
        return this.__minutes.get();
    }
    set minutes(newValue: string) {
        this.__minutes.set(newValue);
    }
    private __seconds: ObservedPropertySimplePU<string>;
    get seconds() {
        return this.__seconds.get();
    }
    set seconds(newValue: string) {
        this.__seconds.set(newValue);
    }
    private __isRunning: ObservedPropertySimplePU<boolean>;
    get isRunning() {
        return this.__isRunning.get();
    }
    set isRunning(newValue: boolean) {
        this.__isRunning.set(newValue);
    }
    private __timeLeft: ObservedPropertySimplePU<number>;
    get timeLeft() {
        return this.__timeLeft.get();
    }
    set timeLeft(newValue: number) {
        this.__timeLeft.set(newValue);
    }
    private timerId: number;
    aboutToDisappear() {
        if (this.timerId !== -1) {
            clearTimeout(this.timerId);
        }
    }
    startTimer() {
        if (this.isRunning)
            return;
        const totalSeconds = (parseInt(this.hours) || 0) * 3600 +
            (parseInt(this.minutes) || 0) * 60 +
            (parseInt(this.seconds) || 0);
        if (totalSeconds <= 0) {
            // 注意：API 10 中 showToast 已废弃，但 DevEco 仍支持（会警告但能运行）
            // 更推荐用 AlertDialog，但为简化，这里保留
            promptAction.showToast({ message: '请输入有效时间' });
            return;
        }
        this.timeLeft = totalSeconds;
        this.isRunning = true;
        this.tick();
    }
    tick() {
        if (this.timeLeft <= 0) {
            this.isRunning = false;
            promptAction.showToast({ message: '时间到！', duration: 3000 });
            return;
        }
        if (this.isRunning) {
            this.timeLeft--;
            this.timerId = setTimeout(() => {
                this.tick();
            }, 1000);
        }
    }
    pauseTimer() {
        this.isRunning = false;
        if (this.timerId !== -1) {
            clearTimeout(this.timerId);
            this.timerId = -1;
        }
    }
    resetTimer() {
        this.pauseTimer();
        this.hours = '0';
        this.minutes = '0';
        this.seconds = '0';
        this.timeLeft = 0;
    }
    formatTime(seconds: number): string {
        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);
        const s = seconds % 60;
        return `${h.toString().padStart(2, '0')}:${m.toString().padStart(2, '0')}:${s.toString().padStart(2, '0')}`;
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create({ space: 20 });
            Column.width('100%');
            Column.height('100%');
            Column.padding(20);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('⏳ 倒计时器');
            Text.fontSize(28);
            Text.fontWeight(FontWeight.Bold);
            Text.margin({ top: 50 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.formatTime(this.timeLeft));
            Text.fontSize(48);
            Text.fontColor('#2c3e50');
            Text.margin({ top: 20 });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 10 });
            Row.margin({ top: 30 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TextInput.create({ placeholder: '时', text: this.hours });
            TextInput.type(InputType.Number);
            TextInput.width(80);
            TextInput.onChange((value) => { this.hours = value; });
        }, TextInput);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(':');
            Text.fontSize(24);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TextInput.create({ placeholder: '分', text: this.minutes });
            TextInput.type(InputType.Number);
            TextInput.width(80);
            TextInput.onChange((value) => { this.minutes = value; });
        }, TextInput);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(':');
            Text.fontSize(24);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TextInput.create({ placeholder: '秒', text: this.seconds });
            TextInput.type(InputType.Number);
            TextInput.width(80);
            TextInput.onChange((value) => { this.seconds = value; });
        }, TextInput);
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create({ space: 20 });
            Row.margin({ top: 30 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel(this.isRunning ? '暂停' : '开始');
            Button.onClick(() => {
                if (this.isRunning)
                    this.pauseTimer();
                else
                    this.startTimer();
            });
            Button.width(100);
            Button.height(40);
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('重置');
            Button.onClick(() => this.resetTimer());
            Button.width(100);
            Button.height(40);
            Button.backgroundColor('#e74c3c');
            Button.fontColor(Color.White);
        }, Button);
        Button.pop();
        Row.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.example.timerapp", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
