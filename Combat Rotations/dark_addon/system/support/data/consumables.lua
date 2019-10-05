local addon, dark_addon = ...



if usable(item.CombatHealingPotion) then return use(item.CombatHealingPotion) end

dark_addon.data.consumables = {
  CombatHealingPotion = 18839,
  CombatManaPotion = 18841,
  CowardlyFlightPotion = 5632,
  DietMcweaksauce = 23578,
  DiscoloredHealingPotion = 4596,
  DreamlessSleepPotion = 12190,
  ElixirOfPoisonResistance = 3386,
  FireProtectionPotion = 6049,
  FlaskOfPetrification = 13506,
  FreeActionPotion = 5634,
  FrostProtectionPotion = 6050,
  GreatRagePotion = 5633,
  GreaterArcaneProtectionPotion = 13461,
  GreaterDreamlessSleepPotion = 20002,
  GreaterFireProtectionPotion = 13457,
  GreaterFrostProtectionPotion = 13456,
  GreaterHealingPotion = 1710,
  GreaterHolyProtectionPotion = 13460,
  GreaterManaPotion = 6149,
  GreaterNatureProtectionPotion = 13458,
  GreaterShadowProtectionPotion = 13459,
  GreaterStoneshieldPotion = 13455,
  HealingPotion = 929,
  HolyProtectionPotion = 6051,
  InvisibilityPotion = 9172,
  LesserHealingPotion = 858,
  LesserInvisibilityPotion = 3823,
  LesserManaPotion = 3385,
  LesserStoneshieldPotion = 4623,
  LightOfElune = 5816,
  LimitedInvulnerabilityPotion = 3387,
  LivingActionPotion = 20008,
  MajorHealingDraught = 17348,
  MajorHealingPotion = 13446,
  MajorManaDraught = 17351,
  MajorManaPotion = 13444,
  MajorRejuvenationPotion = 18253,
  ManaPotion = 3827,
  MightyRagePotion = { 13442 },
  MinorHealingPotion = 118,
  MinorManaPotion = 2455,
  MinorRejuvenationPotion = 2456,
  MugOfShimmerStout = 3087,
  NatureProtectionPotion = 6052,
  PHNatureResistPotionDep = 23698,
  PHPotionOfHeightenedSensesDep = 23696,
  PotionOfFervor = 1450,
  PurificationPotion = 13462,
  RagePotion = { 5631 },
  RestorativePotion = 9030,
  ShadowProtectionPotion = 6048,
  SuperiorHealingDraught = 17349,
  SuperiorHealingPotion = 3928,
  SuperiorManaDraught = 17352,
  SuperiorManaPotion = 13443,
  SwiftnessPotion = 2459,
  SwimSpeedPotion = 6372,
  TheMcweaksauceClassic = 23579,
  WildvinePotion = 9144,
  -- Flasks
  FlaskOfChromaticResistance = 13513,
  FlaskOfDistilledWisdom = 13511,
  FlaskOfSupremePower = 13512,
  FlaskOfTheTitans = 13510,
  -- Elixirs
  ArcaneElixir = 9155,
  CatseyeElixir = 10592,
  CerebralCortexCompound = 8423,
  ElixirOfAgility = 8949,
  ElixirOfBruteForce = 13453,
  ElixirOfDefense = 3389,
  ElixirOfDemonslaying = 9224,
  ElixirOfDetectDemon = 9233,
  ElixirOfDetectLesserInvisibility = 3828,
  ElixirOfDetectUndead = 9154,
  ElixirOfDreamVision = 9197,
  ElixirOfFirepower = 6373,
  ElixirOfFortitude = 3825,
  ElixirOfFrostPower = 17708,
  ElixirOfGiantGrowth = 6662,
  ElixirOfGiants = 9206,
  ElixirOfGreaterAgility = 9187,
  ElixirOfGreaterDefense = 8951,
  ElixirOfGreaterFirepower = 21546,
  ElixirOfGreaterIntellect = 9179,
  ElixirOfGreaterWaterBreathing = 18294,
  ElixirOfLesserAgility = 3390,
  ElixirOfLionsStrength = 2454,
  ElixirOfMinorAgility = 2457,
  ElixirOfMinorDefense = 5997,
  ElixirOfMinorFortitude = 2458,
  ElixirOfOgresStrength = 3391,
  ElixirOfShadowPower = 9264,
  ElixirOfSuperiorDefense = 13445,
  ElixirOfTheMongoose = 13452,
  ElixirOfTheSages = 13447,
  ElixirOfWaterBreathing = 5996,
  ElixirOfWaterWalking = 8827,
  ElixirOfWisdom = 3383,
  GiftOfArthas = 9088,
  GizzardGum = 8424,
  GreaterArcaneElixir = 13454,
  GroundScorpokAssay = 8412,
  LungJuiceCocktail = 8411,
  MagebloodPotion = 20007,
  MajorTrollsBloodPotion = 20004,
  MightyTrollsBloodPotion = 3826,
  NoggenfoggerElixir = 8529,
  ROIDS = 8410,
  SheenOfZanza = 20080,
  SpiritOfZanza = 20079,
  StrongTrollsBloodPotion = 3388,
  SwiftnessOfZanza = 20081,
  WeakTrollsBloodPotion = 3382,
  WinterfallFirewater = 12820,
  -- Scrolls
  ScrollOfAgility = 3012,
  ScrollOfAgilityII = 1477,
  ScrollOfAgilityIII = 4425,
  ScrollOfAgilityIV = 10309,
  ScrollOfIntellect = 955,
  ScrollOfIntellectII = 2290,
  ScrollOfIntellectIII = 4419,
  ScrollOfIntellectIV = 10308,
  ScrollOfProtection = 3013,
  ScrollOfProtectionII = 1478,
  ScrollOfProtectionIII = 4421,
  ScrollOfProtectionIV = 10305,
  ScrollOfSpirit = 1181,
  ScrollOfSpiritII = 1712,
  ScrollOfSpiritIII = 4424,
  ScrollOfSpiritIV = 10306,
  ScrollOfStamina = 1180,
  ScrollOfStaminaII = 1711,
  ScrollOfStaminaIII = 4422,
  ScrollOfStaminaIV = 10307,
  ScrollOfStrength = 954,
  ScrollOfStrengthII = 2289,
  ScrollOfStrengthIII = 4426,
  ScrollOfStrengthIV = 10310,
  -- Bandanges
  AlteracHeavyRuneclothBandage = 19307,
  ArathiBasinMageweaveBandage = 20065,
  ArathiBasinRuneclothBandage = 20066,
  ArathiBasinSilkBandage = 20067,
  CrystalInfusedBandage = 23684,
  DefilersMageweaveBandage = 20232,
  DefilersRuneclothBandage = 20234,
  DefilersSilkBandage = 20235,
  HeavyLinenBandage = 2581,
  HeavyMageweaveBandage = 8545,
  HeavyRuneclothBandage = 14530,
  HeavySilkBandage = 6451,
  HeavyWoolBandage = 3531,
  HighlandersMageweaveBandage = 20237,
  HighlandersRuneclothBandage = 20243,
  HighlandersSilkBandage = 20244,
  LinenBandage = 1251,
  MageweaveBandage = 8544,
  RuneclothBandage = 14529,
  SilkBandage = 6450,
  WarsongGulchMageweaveBandage = 19067,
  WarsongGulchRuneclothBandage = 19066,
  WarsongGulchSilkBandage = 19068,
  WoolBandage = 3530,
  -- Items
  AquadynamicFishAttractor = 6533,
  AquadynamicFishLens = 6811,
  BlessedWizardOil = 23123,
  BrightBaubles = 6532,
  BrilliantManaOil = 20748,
  BrilliantWizardOil = 20749,
  CoarseSharpeningStone = 2863,
  CoarseWeightstone = 3240,
  ConsecratedSharpeningStone = 23122,
  CripplingPoison = 3775,
  CripplingPoisonII = 3776,
  DeadlyPoison = 2892,
  DeadlyPoisonII = 2893,
  DeadlyPoisonIII = 8984,
  DeadlyPoisonIV = 8985,
  DeadlyPoisonV = 20844,
  DenseSharpeningStone = 12404,
  DenseWeightstone = 12643,
  ElementalSharpeningStone = 18262,
  FleshEatingWorm = 7307,
  FrostOil = 3829,
  HeavySharpeningStone = 2871,
  HeavyWeightstone = 3241,
  InstantPoison = 6947,
  InstantPoisonII = 6949,
  InstantPoisonIII = 6950,
  InstantPoisonIv = 8926,
  InstantPoisonV = 8927,
  InstantPoisonVI = 8928,
  InstantToxin = 5654,
  LesserManaOil = 20747,
  LesserWizardOil = 20746,
  MindNumbingPoison = 5237,
  MindNumbingPoisonII = 6951,
  MindNumbingPoisonIII = 9186,
  MinorManaOil = 20745,
  MinorWizardOil = 20744,
  Nightcrawlers = 6530,
  RoughSharpeningStone = 2862,
  RoughWeightstone = 3239,
  ShadowOil = 3824,
  ShinyBauble = 6529,
  SolidSharpeningStone = 7964,
  SolidWeightstone = 7965,
  WizardOil = 20750,
  WoundPoison = 10918,
  WoundPoisonII = 10920,
  WoundPoisonIII = 10921,
  WoundPoisonIV = 10922
}