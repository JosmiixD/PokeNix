part of 'helpers.dart';

pokemonStatNameFormated( int index ) {

  switch (index) {
    case 0:
      return 'HP';
      break;
    case 1:
      return 'Attack';
      break;
    case 2:
      return 'Defense';
      break;
    case 3:
      return 'Sp. Atk';
      break;
    case 4:
      return 'Sp. Def';
      break;
    case 5:
      return 'Speed';
      break;
  }

}

pokemonMaxStat( bool isHp, int baseStat ) {

  double maxStat = baseStat * 2.0;
  maxStat += isHp ? 204 : 99;

  maxStat *= isHp ? 1.0 : 1.1;

  return maxStat.floor();
  

}

pokemonStatPercent( int baseStatPlusEffort, int maxStat ) {

  return (((baseStatPlusEffort * 2 ) * 100) / maxStat) / 100;
}

String pokemonTotalStat( List<Stat> stats ) {

  int total = 0;
  stats.asMap().forEach((index, stat) {
    total += stat.baseStat;
  });

  return total.toString();

}
