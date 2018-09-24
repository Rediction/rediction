export default {
  // 数値を3桁おきにカンマで区切る処理
  separateByComma: (num: number): string => {
    return String(num).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");
  }
};
