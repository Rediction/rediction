import * as React from "react";
import FetchedWordInterface from "../../providers/Word/FetchedWordInterface";
import Card from "../atoms/Card";

interface Props {
  word: FetchedWordInterface;
  intervalSpace: string;
}

const WordCard: React.SFC<Props> = ({ word, intervalSpace }) => {
  return (
    <Card link={`/words/${word.id}`}>
      <div style={{ ...styles.container, marginBottom: `${intervalSpace}px` }}>
        <h4>言葉</h4>
        <p>ID : {word.id}</p>
        <p>意味 : {word.name}</p>
        <p>フリガナ : {word.phonetic}</p>
        <p>定義 : {word.description}</p>

        <h4>プロフィール</h4>
        <p>氏名 : {word.profile.first_name + word.profile.last_name}</p>
        <p>
          フリガナ :{" "}
          {word.profile.first_name_kana + word.profile.last_name_kana}
        </p>
        <p>生年月日 : {word.profile.birth_on}</p>
        <p>職業 : {word.profile.job}</p>
      </div>
    </Card>
  );
};

const styles = {
  container: {
    padding: "17px 22px 11px 10px"
  }
};

export default WordCard;
