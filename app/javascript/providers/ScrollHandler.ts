import $ from "jquery";

interface ScrollHandlerInterface {
  setActionWhenBottomOfElm(targetIdAttr: string, callBackMethod: any): void;
  currentPageOffsetBottom(): number;
  elmOffsetBottom(jqueryElm: any): number;
  scrollTopOffset(): number;
  setScrollEvent(callBackMethod: any): void;
}

class ScrollHandler implements ScrollHandlerInterface {
  private activateThresholdPx: number = 50;

  // 対象部品の最下部から一定距離になった時にメソッドを実行する処理
  setActionWhenBottomOfElm(targetIdAttr: string, callBackMethod: any) {
    this.setScrollEvent(() => {
      const threshold =
        this.elmOffsetBottom($(`#${targetIdAttr}`)) - this.activateThresholdPx;

      // ページ位置が閾値を超えた時にメソッドを実行
      if (this.currentPageOffsetBottom() > threshold) {
        callBackMethod();
      }
    });
  }

  // ページ最上部から表示画面の最下部までの幅を取得
  currentPageOffsetBottom() {
    return this.scrollTopOffset() + window.innerHeight;
  }

  // 部品の最下部の位置を取得
  elmOffsetBottom(jqueryElm: any) {
    return jqueryElm.offset().top + jqueryElm.height();
  }

  // 画面上のOffsetを取得
  scrollTopOffset() {
    return Math.max(
      window.pageYOffset,
      document.documentElement.scrollTop,
      document.body.scrollTop
    );
  }

  // スクロールイベントを設定
  setScrollEvent(callBackMethod: any) {
    window.addEventListener("scroll", callBackMethod, true);
  }
}

export default ScrollHandler;
