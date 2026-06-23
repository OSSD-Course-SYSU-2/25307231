@Component
export struct Tile {
  @Prop num: number = 0;
  @Prop isDark: boolean = false;

  private getBgColor(): string {
    const colors: Record<number, string> = {
      0: "#CDC1B4", 2: "#EEE4DA", 4: "#EDE0C8", 8: "#F2B179",
      16: "#F59563", 32: "#F67C5F", 64: "#F65E3B", 128: "#EDCF72",
      256: "#EDCC61", 512: "#EDC850", 1024: "#EDC53F", 2048: "#EDC22E"
    };
    return colors[this.num] || "#333333";
  }

  private getTextColor(): string {
    return this.num <= 4 ? "#776E65" : "#FFFFFF";
  }

  private getFontSize(): number {
    return this.num >= 1024 ? 16 : 24;
  }

  build() {
    Text(this.num === 0 ? '' : this.num.toString())
      .fontSize(this.getFontSize())
      .fontWeight(FontWeight.Bold)
      .fontColor(this.getTextColor())
      .width("100%")
      .height("100%")
      .textAlign(TextAlign.Center)
      .backgroundColor(this.getBgColor())
      .borderRadius(8)
      .shadow({ radius: 4, color: "rgba(0,0,0,0.1)", offsetX: 2, offsetY: 2 })
  }
}