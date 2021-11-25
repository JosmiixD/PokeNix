
part of 'helpers.dart';

String getCatchRate( int catchRate ) {

  final percent = ((catchRate * 100) / 255).toStringAsFixed(1);

  return '($percent%)';
  
}

String getGrowthRate( String growthRate ) {

  return growthRate.split('-').map((str) => toBeginningOfSentenceCase(str)).join(' ');
  
}

String getEggGroups( List groups ) {

  String groupsAsString = '';

  groups.asMap().forEach((index, group) {
    groupsAsString += '${toBeginningOfSentenceCase(group.name)}${(groups.asMap().length -1 == index ? '' : ',')} ';
  });

  return groupsAsString;
  
}

String getGenderRate( int genderRate ) {
  
  final femaleGenderRate =  (genderRate/8) * 100;

  return '♀ ${100 - femaleGenderRate}%,♂ $femaleGenderRate%';

}

/**
 * Good question! I was just looking at this myself, those other questions reminded me I need to add this to the pokedex here :)

Yes, there is a formula, which is not too difficult. Your stat will be twice the base stat plus 5 (or plus 110 for HP), plus any modifiers like IV, EV and Nature.

Maximum IV is 31.
Mavimum EV is 255, which is 63 stat points.
Nature adds on an extra 10%, (not for HP).
So you get: ( BaseStat × 2 + 5 + 31 + 63 ) × 1.1 with 10 instead of 5 for HP. Then you round it down afterwards.

FORMULA FOR HP:
BaseStat × 2 + 204

FORMULA FOR OTHER STATS:
( BaseStat × 2 + 99 ) × 1.1

EXAMPLE:
Rampardos has a huge 165 base stat in attack. His max would be:
( 165 × 2 + 99 ) × 1.1 = 471.9 --> rounded down to 471.
 * 
 */