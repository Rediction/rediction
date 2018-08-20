interface FetchedWord {
  id: number;
  name: string;
  phonetic: string;
  description: string;
  is_favorite: boolean;
  profile: Profile;
}

interface Profile {
  id: number;
  user_id: number;
  last_name: string;
  last_name_kana: string;
  first_name: string;
  first_name_kana: string;
  birth_on: string;
  job: string;
}

export default FetchedWord;
