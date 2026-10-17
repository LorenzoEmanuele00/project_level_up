// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HeroesTable extends Heroes with TableInfo<$HeroesTable, HeroRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HeroesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AvatarMode, String> avatarMode =
      GeneratedColumn<String>(
        'avatar_mode',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AvatarMode>($HeroesTable.$converteravatarMode);
  static const VerificationMeta _avatarIconMeta = const VerificationMeta(
    'avatarIcon',
  );
  @override
  late final GeneratedColumn<String> avatarIcon = GeneratedColumn<String>(
    'avatar_icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AccentKey, String> accent =
      GeneratedColumn<String>(
        'accent',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<AccentKey>($HeroesTable.$converteraccent);
  @override
  late final GeneratedColumnWithTypeConverter<HeroClass?, String> heroClass =
      GeneratedColumn<String>(
        'hero_class',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<HeroClass?>($HeroesTable.$converterheroClassn);
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    check: () => ComparableExpr(level).isBiggerOrEqualValue(1),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expMeta = const VerificationMeta('exp');
  @override
  late final GeneratedColumn<int> exp = GeneratedColumn<int>(
    'exp',
    aliasedName,
    false,
    check: () => ComparableExpr(exp).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rewardPointsMeta = const VerificationMeta(
    'rewardPoints',
  );
  @override
  late final GeneratedColumn<int> rewardPoints = GeneratedColumn<int>(
    'reward_points',
    aliasedName,
    false,
    check: () => ComparableExpr(rewardPoints).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ThemeKey, String> theme =
      GeneratedColumn<String>(
        'theme',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ThemeKey>($HeroesTable.$convertertheme);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($HeroesTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($HeroesTable.$converterupdatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    name,
    avatarMode,
    avatarIcon,
    accent,
    heroClass,
    level,
    exp,
    rewardPoints,
    theme,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'heroes';
  @override
  VerificationContext validateIntegrity(
    Insertable<HeroRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('avatar_icon')) {
      context.handle(
        _avatarIconMeta,
        avatarIcon.isAcceptableOrUnknown(data['avatar_icon']!, _avatarIconMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('exp')) {
      context.handle(
        _expMeta,
        exp.isAcceptableOrUnknown(data['exp']!, _expMeta),
      );
    } else if (isInserting) {
      context.missing(_expMeta);
    }
    if (data.containsKey('reward_points')) {
      context.handle(
        _rewardPointsMeta,
        rewardPoints.isAcceptableOrUnknown(
          data['reward_points']!,
          _rewardPointsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rewardPointsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HeroRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HeroRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      avatarMode: $HeroesTable.$converteravatarMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}avatar_mode'],
        )!,
      ),
      avatarIcon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_icon'],
      ),
      accent: $HeroesTable.$converteraccent.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}accent'],
        )!,
      ),
      heroClass: $HeroesTable.$converterheroClassn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}hero_class'],
        ),
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      exp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exp'],
      )!,
      rewardPoints: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reward_points'],
      )!,
      theme: $HeroesTable.$convertertheme.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}theme'],
        )!,
      ),
      createdAt: $HeroesTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $HeroesTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
    );
  }

  @override
  $HeroesTable createAlias(String alias) {
    return $HeroesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AvatarMode, String, String> $converteravatarMode =
      const EnumNameConverter<AvatarMode>(AvatarMode.values);
  static JsonTypeConverter2<AccentKey, String, String> $converteraccent =
      const EnumNameConverter<AccentKey>(AccentKey.values);
  static JsonTypeConverter2<HeroClass, String, String> $converterheroClass =
      const EnumNameConverter<HeroClass>(HeroClass.values);
  static JsonTypeConverter2<HeroClass?, String?, String?> $converterheroClassn =
      JsonTypeConverter2.asNullable($converterheroClass);
  static JsonTypeConverter2<ThemeKey, String, String> $convertertheme =
      const EnumNameConverter<ThemeKey>(ThemeKey.values);
  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
}

class HeroRow extends DataClass implements Insertable<HeroRow> {
  final String id;
  final String? userId;
  final String? name;
  final AvatarMode avatarMode;
  final String? avatarIcon;
  final AccentKey accent;
  final HeroClass? heroClass;
  final int level;
  final int exp;
  final int rewardPoints;
  final ThemeKey theme;
  final DateTime createdAt;
  final DateTime updatedAt;
  const HeroRow({
    required this.id,
    this.userId,
    this.name,
    required this.avatarMode,
    this.avatarIcon,
    required this.accent,
    this.heroClass,
    required this.level,
    required this.exp,
    required this.rewardPoints,
    required this.theme,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    {
      map['avatar_mode'] = Variable<String>(
        $HeroesTable.$converteravatarMode.toSql(avatarMode),
      );
    }
    if (!nullToAbsent || avatarIcon != null) {
      map['avatar_icon'] = Variable<String>(avatarIcon);
    }
    {
      map['accent'] = Variable<String>(
        $HeroesTable.$converteraccent.toSql(accent),
      );
    }
    if (!nullToAbsent || heroClass != null) {
      map['hero_class'] = Variable<String>(
        $HeroesTable.$converterheroClassn.toSql(heroClass),
      );
    }
    map['level'] = Variable<int>(level);
    map['exp'] = Variable<int>(exp);
    map['reward_points'] = Variable<int>(rewardPoints);
    {
      map['theme'] = Variable<String>(
        $HeroesTable.$convertertheme.toSql(theme),
      );
    }
    {
      map['created_at'] = Variable<int>(
        $HeroesTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $HeroesTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    return map;
  }

  HeroesCompanion toCompanion(bool nullToAbsent) {
    return HeroesCompanion(
      id: Value(id),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      avatarMode: Value(avatarMode),
      avatarIcon: avatarIcon == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarIcon),
      accent: Value(accent),
      heroClass: heroClass == null && nullToAbsent
          ? const Value.absent()
          : Value(heroClass),
      level: Value(level),
      exp: Value(exp),
      rewardPoints: Value(rewardPoints),
      theme: Value(theme),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HeroRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HeroRow(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String?>(json['userId']),
      name: serializer.fromJson<String?>(json['name']),
      avatarMode: $HeroesTable.$converteravatarMode.fromJson(
        serializer.fromJson<String>(json['avatarMode']),
      ),
      avatarIcon: serializer.fromJson<String?>(json['avatarIcon']),
      accent: $HeroesTable.$converteraccent.fromJson(
        serializer.fromJson<String>(json['accent']),
      ),
      heroClass: $HeroesTable.$converterheroClassn.fromJson(
        serializer.fromJson<String?>(json['heroClass']),
      ),
      level: serializer.fromJson<int>(json['level']),
      exp: serializer.fromJson<int>(json['exp']),
      rewardPoints: serializer.fromJson<int>(json['rewardPoints']),
      theme: $HeroesTable.$convertertheme.fromJson(
        serializer.fromJson<String>(json['theme']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String?>(userId),
      'name': serializer.toJson<String?>(name),
      'avatarMode': serializer.toJson<String>(
        $HeroesTable.$converteravatarMode.toJson(avatarMode),
      ),
      'avatarIcon': serializer.toJson<String?>(avatarIcon),
      'accent': serializer.toJson<String>(
        $HeroesTable.$converteraccent.toJson(accent),
      ),
      'heroClass': serializer.toJson<String?>(
        $HeroesTable.$converterheroClassn.toJson(heroClass),
      ),
      'level': serializer.toJson<int>(level),
      'exp': serializer.toJson<int>(exp),
      'rewardPoints': serializer.toJson<int>(rewardPoints),
      'theme': serializer.toJson<String>(
        $HeroesTable.$convertertheme.toJson(theme),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HeroRow copyWith({
    String? id,
    Value<String?> userId = const Value.absent(),
    Value<String?> name = const Value.absent(),
    AvatarMode? avatarMode,
    Value<String?> avatarIcon = const Value.absent(),
    AccentKey? accent,
    Value<HeroClass?> heroClass = const Value.absent(),
    int? level,
    int? exp,
    int? rewardPoints,
    ThemeKey? theme,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => HeroRow(
    id: id ?? this.id,
    userId: userId.present ? userId.value : this.userId,
    name: name.present ? name.value : this.name,
    avatarMode: avatarMode ?? this.avatarMode,
    avatarIcon: avatarIcon.present ? avatarIcon.value : this.avatarIcon,
    accent: accent ?? this.accent,
    heroClass: heroClass.present ? heroClass.value : this.heroClass,
    level: level ?? this.level,
    exp: exp ?? this.exp,
    rewardPoints: rewardPoints ?? this.rewardPoints,
    theme: theme ?? this.theme,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HeroRow copyWithCompanion(HeroesCompanion data) {
    return HeroRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      avatarMode: data.avatarMode.present
          ? data.avatarMode.value
          : this.avatarMode,
      avatarIcon: data.avatarIcon.present
          ? data.avatarIcon.value
          : this.avatarIcon,
      accent: data.accent.present ? data.accent.value : this.accent,
      heroClass: data.heroClass.present ? data.heroClass.value : this.heroClass,
      level: data.level.present ? data.level.value : this.level,
      exp: data.exp.present ? data.exp.value : this.exp,
      rewardPoints: data.rewardPoints.present
          ? data.rewardPoints.value
          : this.rewardPoints,
      theme: data.theme.present ? data.theme.value : this.theme,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HeroRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('avatarMode: $avatarMode, ')
          ..write('avatarIcon: $avatarIcon, ')
          ..write('accent: $accent, ')
          ..write('heroClass: $heroClass, ')
          ..write('level: $level, ')
          ..write('exp: $exp, ')
          ..write('rewardPoints: $rewardPoints, ')
          ..write('theme: $theme, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    name,
    avatarMode,
    avatarIcon,
    accent,
    heroClass,
    level,
    exp,
    rewardPoints,
    theme,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HeroRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.avatarMode == this.avatarMode &&
          other.avatarIcon == this.avatarIcon &&
          other.accent == this.accent &&
          other.heroClass == this.heroClass &&
          other.level == this.level &&
          other.exp == this.exp &&
          other.rewardPoints == this.rewardPoints &&
          other.theme == this.theme &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HeroesCompanion extends UpdateCompanion<HeroRow> {
  final Value<String> id;
  final Value<String?> userId;
  final Value<String?> name;
  final Value<AvatarMode> avatarMode;
  final Value<String?> avatarIcon;
  final Value<AccentKey> accent;
  final Value<HeroClass?> heroClass;
  final Value<int> level;
  final Value<int> exp;
  final Value<int> rewardPoints;
  final Value<ThemeKey> theme;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HeroesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarMode = const Value.absent(),
    this.avatarIcon = const Value.absent(),
    this.accent = const Value.absent(),
    this.heroClass = const Value.absent(),
    this.level = const Value.absent(),
    this.exp = const Value.absent(),
    this.rewardPoints = const Value.absent(),
    this.theme = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HeroesCompanion.insert({
    required String id,
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    required AvatarMode avatarMode,
    this.avatarIcon = const Value.absent(),
    required AccentKey accent,
    this.heroClass = const Value.absent(),
    required int level,
    required int exp,
    required int rewardPoints,
    required ThemeKey theme,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       avatarMode = Value(avatarMode),
       accent = Value(accent),
       level = Value(level),
       exp = Value(exp),
       rewardPoints = Value(rewardPoints),
       theme = Value(theme),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HeroRow> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? avatarMode,
    Expression<String>? avatarIcon,
    Expression<String>? accent,
    Expression<String>? heroClass,
    Expression<int>? level,
    Expression<int>? exp,
    Expression<int>? rewardPoints,
    Expression<String>? theme,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (avatarMode != null) 'avatar_mode': avatarMode,
      if (avatarIcon != null) 'avatar_icon': avatarIcon,
      if (accent != null) 'accent': accent,
      if (heroClass != null) 'hero_class': heroClass,
      if (level != null) 'level': level,
      if (exp != null) 'exp': exp,
      if (rewardPoints != null) 'reward_points': rewardPoints,
      if (theme != null) 'theme': theme,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HeroesCompanion copyWith({
    Value<String>? id,
    Value<String?>? userId,
    Value<String?>? name,
    Value<AvatarMode>? avatarMode,
    Value<String?>? avatarIcon,
    Value<AccentKey>? accent,
    Value<HeroClass?>? heroClass,
    Value<int>? level,
    Value<int>? exp,
    Value<int>? rewardPoints,
    Value<ThemeKey>? theme,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HeroesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      avatarMode: avatarMode ?? this.avatarMode,
      avatarIcon: avatarIcon ?? this.avatarIcon,
      accent: accent ?? this.accent,
      heroClass: heroClass ?? this.heroClass,
      level: level ?? this.level,
      exp: exp ?? this.exp,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      theme: theme ?? this.theme,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarMode.present) {
      map['avatar_mode'] = Variable<String>(
        $HeroesTable.$converteravatarMode.toSql(avatarMode.value),
      );
    }
    if (avatarIcon.present) {
      map['avatar_icon'] = Variable<String>(avatarIcon.value);
    }
    if (accent.present) {
      map['accent'] = Variable<String>(
        $HeroesTable.$converteraccent.toSql(accent.value),
      );
    }
    if (heroClass.present) {
      map['hero_class'] = Variable<String>(
        $HeroesTable.$converterheroClassn.toSql(heroClass.value),
      );
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (exp.present) {
      map['exp'] = Variable<int>(exp.value);
    }
    if (rewardPoints.present) {
      map['reward_points'] = Variable<int>(rewardPoints.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(
        $HeroesTable.$convertertheme.toSql(theme.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $HeroesTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $HeroesTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HeroesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('avatarMode: $avatarMode, ')
          ..write('avatarIcon: $avatarIcon, ')
          ..write('accent: $accent, ')
          ..write('heroClass: $heroClass, ')
          ..write('level: $level, ')
          ..write('exp: $exp, ')
          ..write('rewardPoints: $rewardPoints, ')
          ..write('theme: $theme, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HabitsTable extends Habits with TableInfo<$HabitsTable, HabitRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HabitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heroIdMeta = const VerificationMeta('heroId');
  @override
  late final GeneratedColumn<String> heroId = GeneratedColumn<String>(
    'hero_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES heroes (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Difficulty, String> difficulty =
      GeneratedColumn<String>(
        'difficulty',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Difficulty>($HabitsTable.$converterdifficulty);
  @override
  late final GeneratedColumnWithTypeConverter<Frequency, String> frequency =
      GeneratedColumn<String>(
        'frequency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Frequency>($HabitsTable.$converterfrequency);
  @override
  late final GeneratedColumnWithTypeConverter<HabitHue, String> hue =
      GeneratedColumn<String>(
        'hue',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<HabitHue>($HabitsTable.$converterhue);
  static const VerificationMeta _streakMeta = const VerificationMeta('streak');
  @override
  late final GeneratedColumn<int> streak = GeneratedColumn<int>(
    'streak',
    aliasedName,
    false,
    check: () => ComparableExpr(streak).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bestStreakMeta = const VerificationMeta(
    'bestStreak',
  );
  @override
  late final GeneratedColumn<int> bestStreak = GeneratedColumn<int>(
    'best_streak',
    aliasedName,
    false,
    check: () => ComparableExpr(bestStreak).isBiggerOrEqual(streak),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCompletionsMeta = const VerificationMeta(
    'totalCompletions',
  );
  @override
  late final GeneratedColumn<int> totalCompletions = GeneratedColumn<int>(
    'total_completions',
    aliasedName,
    false,
    check: () => ComparableExpr(totalCompletions).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($HabitsTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($HabitsTable.$converterupdatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    heroId,
    name,
    icon,
    difficulty,
    frequency,
    hue,
    streak,
    bestStreak,
    totalCompletions,
    archived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'habits';
  @override
  VerificationContext validateIntegrity(
    Insertable<HabitRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hero_id')) {
      context.handle(
        _heroIdMeta,
        heroId.isAcceptableOrUnknown(data['hero_id']!, _heroIdMeta),
      );
    } else if (isInserting) {
      context.missing(_heroIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('streak')) {
      context.handle(
        _streakMeta,
        streak.isAcceptableOrUnknown(data['streak']!, _streakMeta),
      );
    } else if (isInserting) {
      context.missing(_streakMeta);
    }
    if (data.containsKey('best_streak')) {
      context.handle(
        _bestStreakMeta,
        bestStreak.isAcceptableOrUnknown(data['best_streak']!, _bestStreakMeta),
      );
    } else if (isInserting) {
      context.missing(_bestStreakMeta);
    }
    if (data.containsKey('total_completions')) {
      context.handle(
        _totalCompletionsMeta,
        totalCompletions.isAcceptableOrUnknown(
          data['total_completions']!,
          _totalCompletionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalCompletionsMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    } else if (isInserting) {
      context.missing(_archivedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HabitRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HabitRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      heroId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hero_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      difficulty: $HabitsTable.$converterdifficulty.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}difficulty'],
        )!,
      ),
      frequency: $HabitsTable.$converterfrequency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}frequency'],
        )!,
      ),
      hue: $HabitsTable.$converterhue.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}hue'],
        )!,
      ),
      streak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}streak'],
      )!,
      bestStreak: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}best_streak'],
      )!,
      totalCompletions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_completions'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: $HabitsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $HabitsTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
    );
  }

  @override
  $HabitsTable createAlias(String alias) {
    return $HabitsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Difficulty, String, String> $converterdifficulty =
      const EnumNameConverter<Difficulty>(Difficulty.values);
  static JsonTypeConverter2<Frequency, String, String> $converterfrequency =
      const EnumNameConverter<Frequency>(Frequency.values);
  static JsonTypeConverter2<HabitHue, String, String> $converterhue =
      const EnumNameConverter<HabitHue>(HabitHue.values);
  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
}

class HabitRow extends DataClass implements Insertable<HabitRow> {
  final String id;
  final String heroId;
  final String name;
  final String icon;
  final Difficulty difficulty;
  final Frequency frequency;
  final HabitHue hue;
  final int streak;
  final int bestStreak;
  final int totalCompletions;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const HabitRow({
    required this.id,
    required this.heroId,
    required this.name,
    required this.icon,
    required this.difficulty,
    required this.frequency,
    required this.hue,
    required this.streak,
    required this.bestStreak,
    required this.totalCompletions,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hero_id'] = Variable<String>(heroId);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    {
      map['difficulty'] = Variable<String>(
        $HabitsTable.$converterdifficulty.toSql(difficulty),
      );
    }
    {
      map['frequency'] = Variable<String>(
        $HabitsTable.$converterfrequency.toSql(frequency),
      );
    }
    {
      map['hue'] = Variable<String>($HabitsTable.$converterhue.toSql(hue));
    }
    map['streak'] = Variable<int>(streak);
    map['best_streak'] = Variable<int>(bestStreak);
    map['total_completions'] = Variable<int>(totalCompletions);
    map['archived'] = Variable<bool>(archived);
    {
      map['created_at'] = Variable<int>(
        $HabitsTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $HabitsTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    return map;
  }

  HabitsCompanion toCompanion(bool nullToAbsent) {
    return HabitsCompanion(
      id: Value(id),
      heroId: Value(heroId),
      name: Value(name),
      icon: Value(icon),
      difficulty: Value(difficulty),
      frequency: Value(frequency),
      hue: Value(hue),
      streak: Value(streak),
      bestStreak: Value(bestStreak),
      totalCompletions: Value(totalCompletions),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory HabitRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HabitRow(
      id: serializer.fromJson<String>(json['id']),
      heroId: serializer.fromJson<String>(json['heroId']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      difficulty: $HabitsTable.$converterdifficulty.fromJson(
        serializer.fromJson<String>(json['difficulty']),
      ),
      frequency: $HabitsTable.$converterfrequency.fromJson(
        serializer.fromJson<String>(json['frequency']),
      ),
      hue: $HabitsTable.$converterhue.fromJson(
        serializer.fromJson<String>(json['hue']),
      ),
      streak: serializer.fromJson<int>(json['streak']),
      bestStreak: serializer.fromJson<int>(json['bestStreak']),
      totalCompletions: serializer.fromJson<int>(json['totalCompletions']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'heroId': serializer.toJson<String>(heroId),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'difficulty': serializer.toJson<String>(
        $HabitsTable.$converterdifficulty.toJson(difficulty),
      ),
      'frequency': serializer.toJson<String>(
        $HabitsTable.$converterfrequency.toJson(frequency),
      ),
      'hue': serializer.toJson<String>($HabitsTable.$converterhue.toJson(hue)),
      'streak': serializer.toJson<int>(streak),
      'bestStreak': serializer.toJson<int>(bestStreak),
      'totalCompletions': serializer.toJson<int>(totalCompletions),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  HabitRow copyWith({
    String? id,
    String? heroId,
    String? name,
    String? icon,
    Difficulty? difficulty,
    Frequency? frequency,
    HabitHue? hue,
    int? streak,
    int? bestStreak,
    int? totalCompletions,
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => HabitRow(
    id: id ?? this.id,
    heroId: heroId ?? this.heroId,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    difficulty: difficulty ?? this.difficulty,
    frequency: frequency ?? this.frequency,
    hue: hue ?? this.hue,
    streak: streak ?? this.streak,
    bestStreak: bestStreak ?? this.bestStreak,
    totalCompletions: totalCompletions ?? this.totalCompletions,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  HabitRow copyWithCompanion(HabitsCompanion data) {
    return HabitRow(
      id: data.id.present ? data.id.value : this.id,
      heroId: data.heroId.present ? data.heroId.value : this.heroId,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      hue: data.hue.present ? data.hue.value : this.hue,
      streak: data.streak.present ? data.streak.value : this.streak,
      bestStreak: data.bestStreak.present
          ? data.bestStreak.value
          : this.bestStreak,
      totalCompletions: data.totalCompletions.present
          ? data.totalCompletions.value
          : this.totalCompletions,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HabitRow(')
          ..write('id: $id, ')
          ..write('heroId: $heroId, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('difficulty: $difficulty, ')
          ..write('frequency: $frequency, ')
          ..write('hue: $hue, ')
          ..write('streak: $streak, ')
          ..write('bestStreak: $bestStreak, ')
          ..write('totalCompletions: $totalCompletions, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    heroId,
    name,
    icon,
    difficulty,
    frequency,
    hue,
    streak,
    bestStreak,
    totalCompletions,
    archived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HabitRow &&
          other.id == this.id &&
          other.heroId == this.heroId &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.difficulty == this.difficulty &&
          other.frequency == this.frequency &&
          other.hue == this.hue &&
          other.streak == this.streak &&
          other.bestStreak == this.bestStreak &&
          other.totalCompletions == this.totalCompletions &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class HabitsCompanion extends UpdateCompanion<HabitRow> {
  final Value<String> id;
  final Value<String> heroId;
  final Value<String> name;
  final Value<String> icon;
  final Value<Difficulty> difficulty;
  final Value<Frequency> frequency;
  final Value<HabitHue> hue;
  final Value<int> streak;
  final Value<int> bestStreak;
  final Value<int> totalCompletions;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const HabitsCompanion({
    this.id = const Value.absent(),
    this.heroId = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.frequency = const Value.absent(),
    this.hue = const Value.absent(),
    this.streak = const Value.absent(),
    this.bestStreak = const Value.absent(),
    this.totalCompletions = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HabitsCompanion.insert({
    required String id,
    required String heroId,
    required String name,
    required String icon,
    required Difficulty difficulty,
    required Frequency frequency,
    required HabitHue hue,
    required int streak,
    required int bestStreak,
    required int totalCompletions,
    required bool archived,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       heroId = Value(heroId),
       name = Value(name),
       icon = Value(icon),
       difficulty = Value(difficulty),
       frequency = Value(frequency),
       hue = Value(hue),
       streak = Value(streak),
       bestStreak = Value(bestStreak),
       totalCompletions = Value(totalCompletions),
       archived = Value(archived),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<HabitRow> custom({
    Expression<String>? id,
    Expression<String>? heroId,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? difficulty,
    Expression<String>? frequency,
    Expression<String>? hue,
    Expression<int>? streak,
    Expression<int>? bestStreak,
    Expression<int>? totalCompletions,
    Expression<bool>? archived,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (heroId != null) 'hero_id': heroId,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (difficulty != null) 'difficulty': difficulty,
      if (frequency != null) 'frequency': frequency,
      if (hue != null) 'hue': hue,
      if (streak != null) 'streak': streak,
      if (bestStreak != null) 'best_streak': bestStreak,
      if (totalCompletions != null) 'total_completions': totalCompletions,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HabitsCompanion copyWith({
    Value<String>? id,
    Value<String>? heroId,
    Value<String>? name,
    Value<String>? icon,
    Value<Difficulty>? difficulty,
    Value<Frequency>? frequency,
    Value<HabitHue>? hue,
    Value<int>? streak,
    Value<int>? bestStreak,
    Value<int>? totalCompletions,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return HabitsCompanion(
      id: id ?? this.id,
      heroId: heroId ?? this.heroId,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      difficulty: difficulty ?? this.difficulty,
      frequency: frequency ?? this.frequency,
      hue: hue ?? this.hue,
      streak: streak ?? this.streak,
      bestStreak: bestStreak ?? this.bestStreak,
      totalCompletions: totalCompletions ?? this.totalCompletions,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (heroId.present) {
      map['hero_id'] = Variable<String>(heroId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(
        $HabitsTable.$converterdifficulty.toSql(difficulty.value),
      );
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(
        $HabitsTable.$converterfrequency.toSql(frequency.value),
      );
    }
    if (hue.present) {
      map['hue'] = Variable<String>(
        $HabitsTable.$converterhue.toSql(hue.value),
      );
    }
    if (streak.present) {
      map['streak'] = Variable<int>(streak.value);
    }
    if (bestStreak.present) {
      map['best_streak'] = Variable<int>(bestStreak.value);
    }
    if (totalCompletions.present) {
      map['total_completions'] = Variable<int>(totalCompletions.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $HabitsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $HabitsTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HabitsCompanion(')
          ..write('id: $id, ')
          ..write('heroId: $heroId, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('difficulty: $difficulty, ')
          ..write('frequency: $frequency, ')
          ..write('hue: $hue, ')
          ..write('streak: $streak, ')
          ..write('bestStreak: $bestStreak, ')
          ..write('totalCompletions: $totalCompletions, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RewardsTable extends Rewards with TableInfo<$RewardsTable, RewardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RewardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heroIdMeta = const VerificationMeta('heroId');
  @override
  late final GeneratedColumn<String> heroId = GeneratedColumn<String>(
    'hero_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES heroes (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<RewardTier, String> tier =
      GeneratedColumn<String>(
        'tier',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<RewardTier>($RewardsTable.$convertertier);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime?, int> redeemedAt =
      GeneratedColumn<int>(
        'redeemed_at',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<DateTime?>($RewardsTable.$converterredeemedAtn);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($RewardsTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($RewardsTable.$converterupdatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    heroId,
    name,
    note,
    tier,
    redeemedAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rewards';
  @override
  VerificationContext validateIntegrity(
    Insertable<RewardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hero_id')) {
      context.handle(
        _heroIdMeta,
        heroId.isAcceptableOrUnknown(data['hero_id']!, _heroIdMeta),
      );
    } else if (isInserting) {
      context.missing(_heroIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RewardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RewardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      heroId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hero_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      tier: $RewardsTable.$convertertier.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}tier'],
        )!,
      ),
      redeemedAt: $RewardsTable.$converterredeemedAtn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}redeemed_at'],
        ),
      ),
      createdAt: $RewardsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $RewardsTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
    );
  }

  @override
  $RewardsTable createAlias(String alias) {
    return $RewardsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RewardTier, String, String> $convertertier =
      const EnumNameConverter<RewardTier>(RewardTier.values);
  static TypeConverter<DateTime, int> $converterredeemedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime?, int?> $converterredeemedAtn =
      NullAwareTypeConverter.wrap($converterredeemedAt);
  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
}

class RewardRow extends DataClass implements Insertable<RewardRow> {
  final String id;
  final String heroId;
  final String name;
  final String? note;
  final RewardTier tier;
  final DateTime? redeemedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RewardRow({
    required this.id,
    required this.heroId,
    required this.name,
    this.note,
    required this.tier,
    this.redeemedAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hero_id'] = Variable<String>(heroId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    {
      map['tier'] = Variable<String>($RewardsTable.$convertertier.toSql(tier));
    }
    if (!nullToAbsent || redeemedAt != null) {
      map['redeemed_at'] = Variable<int>(
        $RewardsTable.$converterredeemedAtn.toSql(redeemedAt),
      );
    }
    {
      map['created_at'] = Variable<int>(
        $RewardsTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $RewardsTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    return map;
  }

  RewardsCompanion toCompanion(bool nullToAbsent) {
    return RewardsCompanion(
      id: Value(id),
      heroId: Value(heroId),
      name: Value(name),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      tier: Value(tier),
      redeemedAt: redeemedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(redeemedAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RewardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RewardRow(
      id: serializer.fromJson<String>(json['id']),
      heroId: serializer.fromJson<String>(json['heroId']),
      name: serializer.fromJson<String>(json['name']),
      note: serializer.fromJson<String?>(json['note']),
      tier: $RewardsTable.$convertertier.fromJson(
        serializer.fromJson<String>(json['tier']),
      ),
      redeemedAt: serializer.fromJson<DateTime?>(json['redeemedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'heroId': serializer.toJson<String>(heroId),
      'name': serializer.toJson<String>(name),
      'note': serializer.toJson<String?>(note),
      'tier': serializer.toJson<String>(
        $RewardsTable.$convertertier.toJson(tier),
      ),
      'redeemedAt': serializer.toJson<DateTime?>(redeemedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RewardRow copyWith({
    String? id,
    String? heroId,
    String? name,
    Value<String?> note = const Value.absent(),
    RewardTier? tier,
    Value<DateTime?> redeemedAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RewardRow(
    id: id ?? this.id,
    heroId: heroId ?? this.heroId,
    name: name ?? this.name,
    note: note.present ? note.value : this.note,
    tier: tier ?? this.tier,
    redeemedAt: redeemedAt.present ? redeemedAt.value : this.redeemedAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RewardRow copyWithCompanion(RewardsCompanion data) {
    return RewardRow(
      id: data.id.present ? data.id.value : this.id,
      heroId: data.heroId.present ? data.heroId.value : this.heroId,
      name: data.name.present ? data.name.value : this.name,
      note: data.note.present ? data.note.value : this.note,
      tier: data.tier.present ? data.tier.value : this.tier,
      redeemedAt: data.redeemedAt.present
          ? data.redeemedAt.value
          : this.redeemedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RewardRow(')
          ..write('id: $id, ')
          ..write('heroId: $heroId, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('tier: $tier, ')
          ..write('redeemedAt: $redeemedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    heroId,
    name,
    note,
    tier,
    redeemedAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RewardRow &&
          other.id == this.id &&
          other.heroId == this.heroId &&
          other.name == this.name &&
          other.note == this.note &&
          other.tier == this.tier &&
          other.redeemedAt == this.redeemedAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RewardsCompanion extends UpdateCompanion<RewardRow> {
  final Value<String> id;
  final Value<String> heroId;
  final Value<String> name;
  final Value<String?> note;
  final Value<RewardTier> tier;
  final Value<DateTime?> redeemedAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RewardsCompanion({
    this.id = const Value.absent(),
    this.heroId = const Value.absent(),
    this.name = const Value.absent(),
    this.note = const Value.absent(),
    this.tier = const Value.absent(),
    this.redeemedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RewardsCompanion.insert({
    required String id,
    required String heroId,
    required String name,
    this.note = const Value.absent(),
    required RewardTier tier,
    this.redeemedAt = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       heroId = Value(heroId),
       name = Value(name),
       tier = Value(tier),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RewardRow> custom({
    Expression<String>? id,
    Expression<String>? heroId,
    Expression<String>? name,
    Expression<String>? note,
    Expression<String>? tier,
    Expression<int>? redeemedAt,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (heroId != null) 'hero_id': heroId,
      if (name != null) 'name': name,
      if (note != null) 'note': note,
      if (tier != null) 'tier': tier,
      if (redeemedAt != null) 'redeemed_at': redeemedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RewardsCompanion copyWith({
    Value<String>? id,
    Value<String>? heroId,
    Value<String>? name,
    Value<String?>? note,
    Value<RewardTier>? tier,
    Value<DateTime?>? redeemedAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RewardsCompanion(
      id: id ?? this.id,
      heroId: heroId ?? this.heroId,
      name: name ?? this.name,
      note: note ?? this.note,
      tier: tier ?? this.tier,
      redeemedAt: redeemedAt ?? this.redeemedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (heroId.present) {
      map['hero_id'] = Variable<String>(heroId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(
        $RewardsTable.$convertertier.toSql(tier.value),
      );
    }
    if (redeemedAt.present) {
      map['redeemed_at'] = Variable<int>(
        $RewardsTable.$converterredeemedAtn.toSql(redeemedAt.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $RewardsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $RewardsTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RewardsCompanion(')
          ..write('id: $id, ')
          ..write('heroId: $heroId, ')
          ..write('name: $name, ')
          ..write('note: $note, ')
          ..write('tier: $tier, ')
          ..write('redeemedAt: $redeemedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RedemptionsTable extends Redemptions
    with TableInfo<$RedemptionsTable, RedemptionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RedemptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heroIdMeta = const VerificationMeta('heroId');
  @override
  late final GeneratedColumn<String> heroId = GeneratedColumn<String>(
    'hero_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES heroes (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _rewardNameMeta = const VerificationMeta(
    'rewardName',
  );
  @override
  late final GeneratedColumn<String> rewardName = GeneratedColumn<String>(
    'reward_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
    'cost',
    aliasedName,
    false,
    check: () => ComparableExpr(cost).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelAtMeta = const VerificationMeta(
    'levelAt',
  );
  @override
  late final GeneratedColumn<int> levelAt = GeneratedColumn<int>(
    'level_at',
    aliasedName,
    false,
    check: () => ComparableExpr(levelAt).isBiggerOrEqualValue(1),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> at =
      GeneratedColumn<int>(
        'at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($RedemptionsTable.$converterat);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($RedemptionsTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($RedemptionsTable.$converterupdatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    heroId,
    rewardName,
    cost,
    levelAt,
    at,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'redemptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RedemptionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('hero_id')) {
      context.handle(
        _heroIdMeta,
        heroId.isAcceptableOrUnknown(data['hero_id']!, _heroIdMeta),
      );
    } else if (isInserting) {
      context.missing(_heroIdMeta);
    }
    if (data.containsKey('reward_name')) {
      context.handle(
        _rewardNameMeta,
        rewardName.isAcceptableOrUnknown(data['reward_name']!, _rewardNameMeta),
      );
    } else if (isInserting) {
      context.missing(_rewardNameMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('level_at')) {
      context.handle(
        _levelAtMeta,
        levelAt.isAcceptableOrUnknown(data['level_at']!, _levelAtMeta),
      );
    } else if (isInserting) {
      context.missing(_levelAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RedemptionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RedemptionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      heroId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hero_id'],
      )!,
      rewardName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reward_name'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost'],
      )!,
      levelAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level_at'],
      )!,
      at: $RedemptionsTable.$converterat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}at'],
        )!,
      ),
      createdAt: $RedemptionsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $RedemptionsTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
    );
  }

  @override
  $RedemptionsTable createAlias(String alias) {
    return $RedemptionsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converterat = const UtcMillisConverter();
  static TypeConverter<DateTime, int> $convertercreatedAt =
      const UtcMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
}

class RedemptionRow extends DataClass implements Insertable<RedemptionRow> {
  final String id;
  final String heroId;
  final String rewardName;
  final int cost;
  final int levelAt;
  final DateTime at;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RedemptionRow({
    required this.id,
    required this.heroId,
    required this.rewardName,
    required this.cost,
    required this.levelAt,
    required this.at,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['hero_id'] = Variable<String>(heroId);
    map['reward_name'] = Variable<String>(rewardName);
    map['cost'] = Variable<int>(cost);
    map['level_at'] = Variable<int>(levelAt);
    {
      map['at'] = Variable<int>($RedemptionsTable.$converterat.toSql(at));
    }
    {
      map['created_at'] = Variable<int>(
        $RedemptionsTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $RedemptionsTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    return map;
  }

  RedemptionsCompanion toCompanion(bool nullToAbsent) {
    return RedemptionsCompanion(
      id: Value(id),
      heroId: Value(heroId),
      rewardName: Value(rewardName),
      cost: Value(cost),
      levelAt: Value(levelAt),
      at: Value(at),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RedemptionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RedemptionRow(
      id: serializer.fromJson<String>(json['id']),
      heroId: serializer.fromJson<String>(json['heroId']),
      rewardName: serializer.fromJson<String>(json['rewardName']),
      cost: serializer.fromJson<int>(json['cost']),
      levelAt: serializer.fromJson<int>(json['levelAt']),
      at: serializer.fromJson<DateTime>(json['at']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'heroId': serializer.toJson<String>(heroId),
      'rewardName': serializer.toJson<String>(rewardName),
      'cost': serializer.toJson<int>(cost),
      'levelAt': serializer.toJson<int>(levelAt),
      'at': serializer.toJson<DateTime>(at),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RedemptionRow copyWith({
    String? id,
    String? heroId,
    String? rewardName,
    int? cost,
    int? levelAt,
    DateTime? at,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RedemptionRow(
    id: id ?? this.id,
    heroId: heroId ?? this.heroId,
    rewardName: rewardName ?? this.rewardName,
    cost: cost ?? this.cost,
    levelAt: levelAt ?? this.levelAt,
    at: at ?? this.at,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RedemptionRow copyWithCompanion(RedemptionsCompanion data) {
    return RedemptionRow(
      id: data.id.present ? data.id.value : this.id,
      heroId: data.heroId.present ? data.heroId.value : this.heroId,
      rewardName: data.rewardName.present
          ? data.rewardName.value
          : this.rewardName,
      cost: data.cost.present ? data.cost.value : this.cost,
      levelAt: data.levelAt.present ? data.levelAt.value : this.levelAt,
      at: data.at.present ? data.at.value : this.at,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RedemptionRow(')
          ..write('id: $id, ')
          ..write('heroId: $heroId, ')
          ..write('rewardName: $rewardName, ')
          ..write('cost: $cost, ')
          ..write('levelAt: $levelAt, ')
          ..write('at: $at, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    heroId,
    rewardName,
    cost,
    levelAt,
    at,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RedemptionRow &&
          other.id == this.id &&
          other.heroId == this.heroId &&
          other.rewardName == this.rewardName &&
          other.cost == this.cost &&
          other.levelAt == this.levelAt &&
          other.at == this.at &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RedemptionsCompanion extends UpdateCompanion<RedemptionRow> {
  final Value<String> id;
  final Value<String> heroId;
  final Value<String> rewardName;
  final Value<int> cost;
  final Value<int> levelAt;
  final Value<DateTime> at;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RedemptionsCompanion({
    this.id = const Value.absent(),
    this.heroId = const Value.absent(),
    this.rewardName = const Value.absent(),
    this.cost = const Value.absent(),
    this.levelAt = const Value.absent(),
    this.at = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RedemptionsCompanion.insert({
    required String id,
    required String heroId,
    required String rewardName,
    required int cost,
    required int levelAt,
    required DateTime at,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       heroId = Value(heroId),
       rewardName = Value(rewardName),
       cost = Value(cost),
       levelAt = Value(levelAt),
       at = Value(at),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RedemptionRow> custom({
    Expression<String>? id,
    Expression<String>? heroId,
    Expression<String>? rewardName,
    Expression<int>? cost,
    Expression<int>? levelAt,
    Expression<int>? at,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (heroId != null) 'hero_id': heroId,
      if (rewardName != null) 'reward_name': rewardName,
      if (cost != null) 'cost': cost,
      if (levelAt != null) 'level_at': levelAt,
      if (at != null) 'at': at,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RedemptionsCompanion copyWith({
    Value<String>? id,
    Value<String>? heroId,
    Value<String>? rewardName,
    Value<int>? cost,
    Value<int>? levelAt,
    Value<DateTime>? at,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RedemptionsCompanion(
      id: id ?? this.id,
      heroId: heroId ?? this.heroId,
      rewardName: rewardName ?? this.rewardName,
      cost: cost ?? this.cost,
      levelAt: levelAt ?? this.levelAt,
      at: at ?? this.at,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (heroId.present) {
      map['hero_id'] = Variable<String>(heroId.value);
    }
    if (rewardName.present) {
      map['reward_name'] = Variable<String>(rewardName.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (levelAt.present) {
      map['level_at'] = Variable<int>(levelAt.value);
    }
    if (at.present) {
      map['at'] = Variable<int>($RedemptionsTable.$converterat.toSql(at.value));
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $RedemptionsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $RedemptionsTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RedemptionsCompanion(')
          ..write('id: $id, ')
          ..write('heroId: $heroId, ')
          ..write('rewardName: $rewardName, ')
          ..write('cost: $cost, ')
          ..write('levelAt: $levelAt, ')
          ..write('at: $at, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CompletionsTable extends Completions
    with TableInfo<$CompletionsTable, CompletionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _habitIdMeta = const VerificationMeta(
    'habitId',
  );
  @override
  late final GeneratedColumn<String> habitId = GeneratedColumn<String>(
    'habit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES habits (id) ON DELETE RESTRICT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> at =
      GeneratedColumn<int>(
        'at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($CompletionsTable.$converterat);
  static const VerificationMeta _expMeta = const VerificationMeta('exp');
  @override
  late final GeneratedColumn<int> exp = GeneratedColumn<int>(
    'exp',
    aliasedName,
    false,
    check: () => ComparableExpr(exp).isBiggerOrEqualValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Frequency, String> frequency =
      GeneratedColumn<String>(
        'frequency',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Frequency>($CompletionsTable.$converterfrequency);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($CompletionsTable.$converterupdatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    habitId,
    at,
    exp,
    frequency,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CompletionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('habit_id')) {
      context.handle(
        _habitIdMeta,
        habitId.isAcceptableOrUnknown(data['habit_id']!, _habitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_habitIdMeta);
    }
    if (data.containsKey('exp')) {
      context.handle(
        _expMeta,
        exp.isAcceptableOrUnknown(data['exp']!, _expMeta),
      );
    } else if (isInserting) {
      context.missing(_expMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CompletionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CompletionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      habitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}habit_id'],
      )!,
      at: $CompletionsTable.$converterat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}at'],
        )!,
      ),
      exp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exp'],
      )!,
      frequency: $CompletionsTable.$converterfrequency.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}frequency'],
        )!,
      ),
      updatedAt: $CompletionsTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
    );
  }

  @override
  $CompletionsTable createAlias(String alias) {
    return $CompletionsTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converterat = const UtcMillisConverter();
  static JsonTypeConverter2<Frequency, String, String> $converterfrequency =
      const EnumNameConverter<Frequency>(Frequency.values);
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const UtcMillisConverter();
}

class CompletionRow extends DataClass implements Insertable<CompletionRow> {
  final String id;
  final String habitId;
  final DateTime at;
  final int exp;
  final Frequency frequency;
  final DateTime updatedAt;
  const CompletionRow({
    required this.id,
    required this.habitId,
    required this.at,
    required this.exp,
    required this.frequency,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['habit_id'] = Variable<String>(habitId);
    {
      map['at'] = Variable<int>($CompletionsTable.$converterat.toSql(at));
    }
    map['exp'] = Variable<int>(exp);
    {
      map['frequency'] = Variable<String>(
        $CompletionsTable.$converterfrequency.toSql(frequency),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $CompletionsTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    return map;
  }

  CompletionsCompanion toCompanion(bool nullToAbsent) {
    return CompletionsCompanion(
      id: Value(id),
      habitId: Value(habitId),
      at: Value(at),
      exp: Value(exp),
      frequency: Value(frequency),
      updatedAt: Value(updatedAt),
    );
  }

  factory CompletionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CompletionRow(
      id: serializer.fromJson<String>(json['id']),
      habitId: serializer.fromJson<String>(json['habitId']),
      at: serializer.fromJson<DateTime>(json['at']),
      exp: serializer.fromJson<int>(json['exp']),
      frequency: $CompletionsTable.$converterfrequency.fromJson(
        serializer.fromJson<String>(json['frequency']),
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'habitId': serializer.toJson<String>(habitId),
      'at': serializer.toJson<DateTime>(at),
      'exp': serializer.toJson<int>(exp),
      'frequency': serializer.toJson<String>(
        $CompletionsTable.$converterfrequency.toJson(frequency),
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CompletionRow copyWith({
    String? id,
    String? habitId,
    DateTime? at,
    int? exp,
    Frequency? frequency,
    DateTime? updatedAt,
  }) => CompletionRow(
    id: id ?? this.id,
    habitId: habitId ?? this.habitId,
    at: at ?? this.at,
    exp: exp ?? this.exp,
    frequency: frequency ?? this.frequency,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CompletionRow copyWithCompanion(CompletionsCompanion data) {
    return CompletionRow(
      id: data.id.present ? data.id.value : this.id,
      habitId: data.habitId.present ? data.habitId.value : this.habitId,
      at: data.at.present ? data.at.value : this.at,
      exp: data.exp.present ? data.exp.value : this.exp,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CompletionRow(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('at: $at, ')
          ..write('exp: $exp, ')
          ..write('frequency: $frequency, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, habitId, at, exp, frequency, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CompletionRow &&
          other.id == this.id &&
          other.habitId == this.habitId &&
          other.at == this.at &&
          other.exp == this.exp &&
          other.frequency == this.frequency &&
          other.updatedAt == this.updatedAt);
}

class CompletionsCompanion extends UpdateCompanion<CompletionRow> {
  final Value<String> id;
  final Value<String> habitId;
  final Value<DateTime> at;
  final Value<int> exp;
  final Value<Frequency> frequency;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CompletionsCompanion({
    this.id = const Value.absent(),
    this.habitId = const Value.absent(),
    this.at = const Value.absent(),
    this.exp = const Value.absent(),
    this.frequency = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CompletionsCompanion.insert({
    required String id,
    required String habitId,
    required DateTime at,
    required int exp,
    required Frequency frequency,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       habitId = Value(habitId),
       at = Value(at),
       exp = Value(exp),
       frequency = Value(frequency),
       updatedAt = Value(updatedAt);
  static Insertable<CompletionRow> custom({
    Expression<String>? id,
    Expression<String>? habitId,
    Expression<int>? at,
    Expression<int>? exp,
    Expression<String>? frequency,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (habitId != null) 'habit_id': habitId,
      if (at != null) 'at': at,
      if (exp != null) 'exp': exp,
      if (frequency != null) 'frequency': frequency,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CompletionsCompanion copyWith({
    Value<String>? id,
    Value<String>? habitId,
    Value<DateTime>? at,
    Value<int>? exp,
    Value<Frequency>? frequency,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CompletionsCompanion(
      id: id ?? this.id,
      habitId: habitId ?? this.habitId,
      at: at ?? this.at,
      exp: exp ?? this.exp,
      frequency: frequency ?? this.frequency,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (habitId.present) {
      map['habit_id'] = Variable<String>(habitId.value);
    }
    if (at.present) {
      map['at'] = Variable<int>($CompletionsTable.$converterat.toSql(at.value));
    }
    if (exp.present) {
      map['exp'] = Variable<int>(exp.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(
        $CompletionsTable.$converterfrequency.toSql(frequency.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $CompletionsTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompletionsCompanion(')
          ..write('id: $id, ')
          ..write('habitId: $habitId, ')
          ..write('at: $at, ')
          ..write('exp: $exp, ')
          ..write('frequency: $frequency, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HeroesTable heroes = $HeroesTable(this);
  late final $HabitsTable habits = $HabitsTable(this);
  late final $RewardsTable rewards = $RewardsTable(this);
  late final $RedemptionsTable redemptions = $RedemptionsTable(this);
  late final $CompletionsTable completions = $CompletionsTable(this);
  late final Index heroesUser = Index(
    'heroes_user',
    'CREATE INDEX heroes_user ON heroes (user_id)',
  );
  late final Index habitsHeroArchived = Index(
    'habits_hero_archived',
    'CREATE INDEX habits_hero_archived ON habits (hero_id, archived)',
  );
  late final Index rewardsHero = Index(
    'rewards_hero',
    'CREATE INDEX rewards_hero ON rewards (hero_id)',
  );
  late final Index redemptionsHeroAt = Index(
    'redemptions_hero_at',
    'CREATE INDEX redemptions_hero_at ON redemptions (hero_id, at)',
  );
  late final Index completionsHabitAt = Index(
    'completions_habit_at',
    'CREATE INDEX completions_habit_at ON completions (habit_id, at)',
  );
  late final Index completionsAt = Index(
    'completions_at',
    'CREATE INDEX completions_at ON completions (at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    heroes,
    habits,
    rewards,
    redemptions,
    completions,
    heroesUser,
    habitsHeroArchived,
    rewardsHero,
    redemptionsHeroAt,
    completionsHabitAt,
    completionsAt,
  ];
}

typedef $$HeroesTableCreateCompanionBuilder = HeroesCompanion Function({
  required String id,
  Value<String?> userId,
  Value<String?> name,
  required AvatarMode avatarMode,
  Value<String?> avatarIcon,
  required AccentKey accent,
  Value<HeroClass?> heroClass,
  required int level,
  required int exp,
  required int rewardPoints,
  required ThemeKey theme,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$HeroesTableUpdateCompanionBuilder = HeroesCompanion Function({
  Value<String> id,
  Value<String?> userId,
  Value<String?> name,
  Value<AvatarMode> avatarMode,
  Value<String?> avatarIcon,
  Value<AccentKey> accent,
  Value<HeroClass?> heroClass,
  Value<int> level,
  Value<int> exp,
  Value<int> rewardPoints,
  Value<ThemeKey> theme,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$HeroesTableReferences
    extends BaseReferences<_$AppDatabase, $HeroesTable, HeroRow> {
  $$HeroesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$HabitsTable, List<HabitRow>> _habitsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.habits,
    aliasName: 'heroes__id__habits__hero_id',
  );

  $$HabitsTableProcessedTableManager get habitsRefs {
    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.heroId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_habitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RewardsTable, List<RewardRow>> _rewardsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.rewards,
    aliasName: 'heroes__id__rewards__hero_id',
  );

  $$RewardsTableProcessedTableManager get rewardsRefs {
    final manager = $$RewardsTableTableManager(
      $_db,
      $_db.rewards,
    ).filter((f) => f.heroId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_rewardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RedemptionsTable, List<RedemptionRow>>
  _redemptionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.redemptions,
    aliasName: 'heroes__id__redemptions__hero_id',
  );

  $$RedemptionsTableProcessedTableManager get redemptionsRefs {
    final manager = $$RedemptionsTableTableManager(
      $_db,
      $_db.redemptions,
    ).filter((f) => f.heroId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_redemptionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HeroesTableFilterComposer
    extends Composer<_$AppDatabase, $HeroesTable> {
  $$HeroesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AvatarMode, AvatarMode, String>
  get avatarMode => $composableBuilder(
    column: $table.avatarMode,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get avatarIcon => $composableBuilder(
    column: $table.avatarIcon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AccentKey, AccentKey, String> get accent =>
      $composableBuilder(
        column: $table.accent,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<HeroClass?, HeroClass, String> get heroClass =>
      $composableBuilder(
        column: $table.heroClass,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get exp => $composableBuilder(
    column: $table.exp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rewardPoints => $composableBuilder(
    column: $table.rewardPoints,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ThemeKey, ThemeKey, String> get theme =>
      $composableBuilder(
        column: $table.theme,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> habitsRefs(
    Expression<bool> Function($$HabitsTableFilterComposer f) f,
  ) {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.heroId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> rewardsRefs(
    Expression<bool> Function($$RewardsTableFilterComposer f) f,
  ) {
    final $$RewardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rewards,
      getReferencedColumn: (t) => t.heroId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardsTableFilterComposer(
            $db: $db,
            $table: $db.rewards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> redemptionsRefs(
    Expression<bool> Function($$RedemptionsTableFilterComposer f) f,
  ) {
    final $$RedemptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.redemptions,
      getReferencedColumn: (t) => t.heroId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RedemptionsTableFilterComposer(
            $db: $db,
            $table: $db.redemptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HeroesTableOrderingComposer
    extends Composer<_$AppDatabase, $HeroesTable> {
  $$HeroesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarMode => $composableBuilder(
    column: $table.avatarMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarIcon => $composableBuilder(
    column: $table.avatarIcon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accent => $composableBuilder(
    column: $table.accent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get heroClass => $composableBuilder(
    column: $table.heroClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exp => $composableBuilder(
    column: $table.exp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rewardPoints => $composableBuilder(
    column: $table.rewardPoints,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HeroesTableAnnotationComposer
    extends Composer<_$AppDatabase, $HeroesTable> {
  $$HeroesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AvatarMode, String> get avatarMode =>
      $composableBuilder(
        column: $table.avatarMode,
        builder: (column) => column,
      );

  GeneratedColumn<String> get avatarIcon => $composableBuilder(
    column: $table.avatarIcon,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<AccentKey, String> get accent =>
      $composableBuilder(column: $table.accent, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HeroClass?, String> get heroClass =>
      $composableBuilder(column: $table.heroClass, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get exp =>
      $composableBuilder(column: $table.exp, builder: (column) => column);

  GeneratedColumn<int> get rewardPoints => $composableBuilder(
    column: $table.rewardPoints,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ThemeKey, String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> habitsRefs<T extends Object>(
    Expression<T> Function($$HabitsTableAnnotationComposer a) f,
  ) {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.heroId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> rewardsRefs<T extends Object>(
    Expression<T> Function($$RewardsTableAnnotationComposer a) f,
  ) {
    final $$RewardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rewards,
      getReferencedColumn: (t) => t.heroId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RewardsTableAnnotationComposer(
            $db: $db,
            $table: $db.rewards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> redemptionsRefs<T extends Object>(
    Expression<T> Function($$RedemptionsTableAnnotationComposer a) f,
  ) {
    final $$RedemptionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.redemptions,
      getReferencedColumn: (t) => t.heroId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RedemptionsTableAnnotationComposer(
            $db: $db,
            $table: $db.redemptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HeroesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HeroesTable,
          HeroRow,
          $$HeroesTableFilterComposer,
          $$HeroesTableOrderingComposer,
          $$HeroesTableAnnotationComposer,
          $$HeroesTableCreateCompanionBuilder,
          $$HeroesTableUpdateCompanionBuilder,
          (HeroRow, $$HeroesTableReferences),
          HeroRow,
          PrefetchHooks Function({
            bool habitsRefs,
            bool rewardsRefs,
            bool redemptionsRefs,
          })
        > {
  $$HeroesTableTableManager(_$AppDatabase db, $HeroesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HeroesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HeroesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HeroesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<AvatarMode> avatarMode = const Value.absent(),
                Value<String?> avatarIcon = const Value.absent(),
                Value<AccentKey> accent = const Value.absent(),
                Value<HeroClass?> heroClass = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<int> exp = const Value.absent(),
                Value<int> rewardPoints = const Value.absent(),
                Value<ThemeKey> theme = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HeroesCompanion(
                id: id,
                userId: userId,
                name: name,
                avatarMode: avatarMode,
                avatarIcon: avatarIcon,
                accent: accent,
                heroClass: heroClass,
                level: level,
                exp: exp,
                rewardPoints: rewardPoints,
                theme: theme,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> userId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                required AvatarMode avatarMode,
                Value<String?> avatarIcon = const Value.absent(),
                required AccentKey accent,
                Value<HeroClass?> heroClass = const Value.absent(),
                required int level,
                required int exp,
                required int rewardPoints,
                required ThemeKey theme,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HeroesCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                avatarMode: avatarMode,
                avatarIcon: avatarIcon,
                accent: accent,
                heroClass: heroClass,
                level: level,
                exp: exp,
                rewardPoints: rewardPoints,
                theme: theme,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HeroesTable, HeroRow>(table),
                  $$HeroesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                habitsRefs = false,
                rewardsRefs = false,
                redemptionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (habitsRefs) db.habits,
                    if (rewardsRefs) db.rewards,
                    if (redemptionsRefs) db.redemptions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (habitsRefs)
                        await $_getPrefetchedData<
                          HeroRow,
                          $HeroesTable,
                          HabitRow
                        >(
                          currentTable: table,
                          referencedTable: $$HeroesTableReferences
                              ._habitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HeroesTableReferences(db, table, p0).habitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.heroId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (rewardsRefs)
                        await $_getPrefetchedData<
                          HeroRow,
                          $HeroesTable,
                          RewardRow
                        >(
                          currentTable: table,
                          referencedTable: $$HeroesTableReferences
                              ._rewardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HeroesTableReferences(
                                db,
                                table,
                                p0,
                              ).rewardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.heroId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (redemptionsRefs)
                        await $_getPrefetchedData<
                          HeroRow,
                          $HeroesTable,
                          RedemptionRow
                        >(
                          currentTable: table,
                          referencedTable: $$HeroesTableReferences
                              ._redemptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$HeroesTableReferences(
                                db,
                                table,
                                p0,
                              ).redemptionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.heroId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$HeroesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HeroesTable,
      HeroRow,
      $$HeroesTableFilterComposer,
      $$HeroesTableOrderingComposer,
      $$HeroesTableAnnotationComposer,
      $$HeroesTableCreateCompanionBuilder,
      $$HeroesTableUpdateCompanionBuilder,
      (HeroRow, $$HeroesTableReferences),
      HeroRow,
      PrefetchHooks Function({
        bool habitsRefs,
        bool rewardsRefs,
        bool redemptionsRefs,
      })
    >;
typedef $$HabitsTableCreateCompanionBuilder = HabitsCompanion Function({
  required String id,
  required String heroId,
  required String name,
  required String icon,
  required Difficulty difficulty,
  required Frequency frequency,
  required HabitHue hue,
  required int streak,
  required int bestStreak,
  required int totalCompletions,
  required bool archived,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$HabitsTableUpdateCompanionBuilder = HabitsCompanion Function({
  Value<String> id,
  Value<String> heroId,
  Value<String> name,
  Value<String> icon,
  Value<Difficulty> difficulty,
  Value<Frequency> frequency,
  Value<HabitHue> hue,
  Value<int> streak,
  Value<int> bestStreak,
  Value<int> totalCompletions,
  Value<bool> archived,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$HabitsTableReferences
    extends BaseReferences<_$AppDatabase, $HabitsTable, HabitRow> {
  $$HabitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HeroesTable _heroIdTable(_$AppDatabase db) =>
      db.heroes.createAlias('habits__hero_id__heroes__id');

  $$HeroesTableProcessedTableManager get heroId {
    final $_column = $_itemColumn<String>('hero_id')!;

    final manager = $$HeroesTableTableManager(
      $_db,
      $_db.heroes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_heroIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CompletionsTable, List<CompletionRow>>
  _completionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.completions,
    aliasName: 'habits__id__completions__habit_id',
  );

  $$CompletionsTableProcessedTableManager get completionsRefs {
    final manager = $$CompletionsTableTableManager(
      $_db,
      $_db.completions,
    ).filter((f) => f.habitId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_completionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$HabitsTableFilterComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Difficulty, Difficulty, String>
  get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Frequency, Frequency, String> get frequency =>
      $composableBuilder(
        column: $table.frequency,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<HabitHue, HabitHue, String> get hue =>
      $composableBuilder(
        column: $table.hue,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCompletions => $composableBuilder(
    column: $table.totalCompletions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$HeroesTableFilterComposer get heroId {
    final $$HeroesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.heroId,
      referencedTable: $db.heroes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HeroesTableFilterComposer(
            $db: $db,
            $table: $db.heroes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> completionsRefs(
    Expression<bool> Function($$CompletionsTableFilterComposer f) f,
  ) {
    final $$CompletionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completions,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletionsTableFilterComposer(
            $db: $db,
            $table: $db.completions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableOrderingComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hue => $composableBuilder(
    column: $table.hue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get streak => $composableBuilder(
    column: $table.streak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCompletions => $composableBuilder(
    column: $table.totalCompletions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HeroesTableOrderingComposer get heroId {
    final $$HeroesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.heroId,
      referencedTable: $db.heroes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HeroesTableOrderingComposer(
            $db: $db,
            $table: $db.heroes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HabitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HabitsTable> {
  $$HabitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Difficulty, String> get difficulty =>
      $composableBuilder(
        column: $table.difficulty,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Frequency, String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumnWithTypeConverter<HabitHue, String> get hue =>
      $composableBuilder(column: $table.hue, builder: (column) => column);

  GeneratedColumn<int> get streak =>
      $composableBuilder(column: $table.streak, builder: (column) => column);

  GeneratedColumn<int> get bestStreak => $composableBuilder(
    column: $table.bestStreak,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCompletions => $composableBuilder(
    column: $table.totalCompletions,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HeroesTableAnnotationComposer get heroId {
    final $$HeroesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.heroId,
      referencedTable: $db.heroes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HeroesTableAnnotationComposer(
            $db: $db,
            $table: $db.heroes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> completionsRefs<T extends Object>(
    Expression<T> Function($$CompletionsTableAnnotationComposer a) f,
  ) {
    final $$CompletionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.completions,
      getReferencedColumn: (t) => t.habitId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CompletionsTableAnnotationComposer(
            $db: $db,
            $table: $db.completions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$HabitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HabitsTable,
          HabitRow,
          $$HabitsTableFilterComposer,
          $$HabitsTableOrderingComposer,
          $$HabitsTableAnnotationComposer,
          $$HabitsTableCreateCompanionBuilder,
          $$HabitsTableUpdateCompanionBuilder,
          (HabitRow, $$HabitsTableReferences),
          HabitRow,
          PrefetchHooks Function({bool heroId, bool completionsRefs})
        > {
  $$HabitsTableTableManager(_$AppDatabase db, $HabitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HabitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HabitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HabitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> heroId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<Difficulty> difficulty = const Value.absent(),
                Value<Frequency> frequency = const Value.absent(),
                Value<HabitHue> hue = const Value.absent(),
                Value<int> streak = const Value.absent(),
                Value<int> bestStreak = const Value.absent(),
                Value<int> totalCompletions = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion(
                id: id,
                heroId: heroId,
                name: name,
                icon: icon,
                difficulty: difficulty,
                frequency: frequency,
                hue: hue,
                streak: streak,
                bestStreak: bestStreak,
                totalCompletions: totalCompletions,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String heroId,
                required String name,
                required String icon,
                required Difficulty difficulty,
                required Frequency frequency,
                required HabitHue hue,
                required int streak,
                required int bestStreak,
                required int totalCompletions,
                required bool archived,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => HabitsCompanion.insert(
                id: id,
                heroId: heroId,
                name: name,
                icon: icon,
                difficulty: difficulty,
                frequency: frequency,
                hue: hue,
                streak: streak,
                bestStreak: bestStreak,
                totalCompletions: totalCompletions,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$HabitsTable, HabitRow>(table),
                  $$HabitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({heroId = false, completionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (completionsRefs) db.completions],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (heroId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.heroId,
                        referencedTable: $$HabitsTableReferences._heroIdTable(
                          db,
                        ),
                        referencedColumn: $$HabitsTableReferences
                            ._heroIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (completionsRefs)
                    await $_getPrefetchedData<
                      HabitRow,
                      $HabitsTable,
                      CompletionRow
                    >(
                      currentTable: table,
                      referencedTable: $$HabitsTableReferences
                          ._completionsRefsTable(db),
                      managerFromTypedResult: (p0) => $$HabitsTableReferences(
                        db,
                        table,
                        p0,
                      ).completionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.habitId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$HabitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HabitsTable,
      HabitRow,
      $$HabitsTableFilterComposer,
      $$HabitsTableOrderingComposer,
      $$HabitsTableAnnotationComposer,
      $$HabitsTableCreateCompanionBuilder,
      $$HabitsTableUpdateCompanionBuilder,
      (HabitRow, $$HabitsTableReferences),
      HabitRow,
      PrefetchHooks Function({bool heroId, bool completionsRefs})
    >;
typedef $$RewardsTableCreateCompanionBuilder = RewardsCompanion Function({
  required String id,
  required String heroId,
  required String name,
  Value<String?> note,
  required RewardTier tier,
  Value<DateTime?> redeemedAt,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$RewardsTableUpdateCompanionBuilder = RewardsCompanion Function({
  Value<String> id,
  Value<String> heroId,
  Value<String> name,
  Value<String?> note,
  Value<RewardTier> tier,
  Value<DateTime?> redeemedAt,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

final class $$RewardsTableReferences
    extends BaseReferences<_$AppDatabase, $RewardsTable, RewardRow> {
  $$RewardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HeroesTable _heroIdTable(_$AppDatabase db) =>
      db.heroes.createAlias('rewards__hero_id__heroes__id');

  $$HeroesTableProcessedTableManager get heroId {
    final $_column = $_itemColumn<String>('hero_id')!;

    final manager = $$HeroesTableTableManager(
      $_db,
      $_db.heroes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_heroIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RewardsTableFilterComposer
    extends Composer<_$AppDatabase, $RewardsTable> {
  $$RewardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RewardTier, RewardTier, String> get tier =>
      $composableBuilder(
        column: $table.tier,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime?, DateTime, int> get redeemedAt =>
      $composableBuilder(
        column: $table.redeemedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$HeroesTableFilterComposer get heroId {
    final $$HeroesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.heroId,
      referencedTable: $db.heroes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HeroesTableFilterComposer(
            $db: $db,
            $table: $db.heroes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardsTableOrderingComposer
    extends Composer<_$AppDatabase, $RewardsTable> {
  $$RewardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get redeemedAt => $composableBuilder(
    column: $table.redeemedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HeroesTableOrderingComposer get heroId {
    final $$HeroesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.heroId,
      referencedTable: $db.heroes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HeroesTableOrderingComposer(
            $db: $db,
            $table: $db.heroes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RewardsTable> {
  $$RewardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RewardTier, String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime?, int> get redeemedAt =>
      $composableBuilder(
        column: $table.redeemedAt,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HeroesTableAnnotationComposer get heroId {
    final $$HeroesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.heroId,
      referencedTable: $db.heroes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HeroesTableAnnotationComposer(
            $db: $db,
            $table: $db.heroes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RewardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RewardsTable,
          RewardRow,
          $$RewardsTableFilterComposer,
          $$RewardsTableOrderingComposer,
          $$RewardsTableAnnotationComposer,
          $$RewardsTableCreateCompanionBuilder,
          $$RewardsTableUpdateCompanionBuilder,
          (RewardRow, $$RewardsTableReferences),
          RewardRow,
          PrefetchHooks Function({bool heroId})
        > {
  $$RewardsTableTableManager(_$AppDatabase db, $RewardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RewardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RewardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RewardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> heroId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<RewardTier> tier = const Value.absent(),
                Value<DateTime?> redeemedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RewardsCompanion(
                id: id,
                heroId: heroId,
                name: name,
                note: note,
                tier: tier,
                redeemedAt: redeemedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String heroId,
                required String name,
                Value<String?> note = const Value.absent(),
                required RewardTier tier,
                Value<DateTime?> redeemedAt = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RewardsCompanion.insert(
                id: id,
                heroId: heroId,
                name: name,
                note: note,
                tier: tier,
                redeemedAt: redeemedAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RewardsTable, RewardRow>(table),
                  $$RewardsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({heroId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (heroId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.heroId,
                        referencedTable: $$RewardsTableReferences._heroIdTable(
                          db,
                        ),
                        referencedColumn: $$RewardsTableReferences
                            ._heroIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RewardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RewardsTable,
      RewardRow,
      $$RewardsTableFilterComposer,
      $$RewardsTableOrderingComposer,
      $$RewardsTableAnnotationComposer,
      $$RewardsTableCreateCompanionBuilder,
      $$RewardsTableUpdateCompanionBuilder,
      (RewardRow, $$RewardsTableReferences),
      RewardRow,
      PrefetchHooks Function({bool heroId})
    >;
typedef $$RedemptionsTableCreateCompanionBuilder =
    RedemptionsCompanion Function({
      required String id,
      required String heroId,
      required String rewardName,
      required int cost,
      required int levelAt,
      required DateTime at,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RedemptionsTableUpdateCompanionBuilder =
    RedemptionsCompanion Function({
      Value<String> id,
      Value<String> heroId,
      Value<String> rewardName,
      Value<int> cost,
      Value<int> levelAt,
      Value<DateTime> at,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RedemptionsTableReferences
    extends BaseReferences<_$AppDatabase, $RedemptionsTable, RedemptionRow> {
  $$RedemptionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HeroesTable _heroIdTable(_$AppDatabase db) =>
      db.heroes.createAlias('redemptions__hero_id__heroes__id');

  $$HeroesTableProcessedTableManager get heroId {
    final $_column = $_itemColumn<String>('hero_id')!;

    final manager = $$HeroesTableTableManager(
      $_db,
      $_db.heroes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_heroIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RedemptionsTableFilterComposer
    extends Composer<_$AppDatabase, $RedemptionsTable> {
  $$RedemptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rewardName => $composableBuilder(
    column: $table.rewardName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get levelAt => $composableBuilder(
    column: $table.levelAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get at =>
      $composableBuilder(
        column: $table.at,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$HeroesTableFilterComposer get heroId {
    final $$HeroesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.heroId,
      referencedTable: $db.heroes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HeroesTableFilterComposer(
            $db: $db,
            $table: $db.heroes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RedemptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RedemptionsTable> {
  $$RedemptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rewardName => $composableBuilder(
    column: $table.rewardName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get levelAt => $composableBuilder(
    column: $table.levelAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HeroesTableOrderingComposer get heroId {
    final $$HeroesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.heroId,
      referencedTable: $db.heroes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HeroesTableOrderingComposer(
            $db: $db,
            $table: $db.heroes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RedemptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RedemptionsTable> {
  $$RedemptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rewardName => $composableBuilder(
    column: $table.rewardName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<int> get levelAt =>
      $composableBuilder(column: $table.levelAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HeroesTableAnnotationComposer get heroId {
    final $$HeroesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.heroId,
      referencedTable: $db.heroes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HeroesTableAnnotationComposer(
            $db: $db,
            $table: $db.heroes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RedemptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RedemptionsTable,
          RedemptionRow,
          $$RedemptionsTableFilterComposer,
          $$RedemptionsTableOrderingComposer,
          $$RedemptionsTableAnnotationComposer,
          $$RedemptionsTableCreateCompanionBuilder,
          $$RedemptionsTableUpdateCompanionBuilder,
          (RedemptionRow, $$RedemptionsTableReferences),
          RedemptionRow,
          PrefetchHooks Function({bool heroId})
        > {
  $$RedemptionsTableTableManager(_$AppDatabase db, $RedemptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RedemptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RedemptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RedemptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> heroId = const Value.absent(),
                Value<String> rewardName = const Value.absent(),
                Value<int> cost = const Value.absent(),
                Value<int> levelAt = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RedemptionsCompanion(
                id: id,
                heroId: heroId,
                rewardName: rewardName,
                cost: cost,
                levelAt: levelAt,
                at: at,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String heroId,
                required String rewardName,
                required int cost,
                required int levelAt,
                required DateTime at,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RedemptionsCompanion.insert(
                id: id,
                heroId: heroId,
                rewardName: rewardName,
                cost: cost,
                levelAt: levelAt,
                at: at,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RedemptionsTable, RedemptionRow>(table),
                  $$RedemptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({heroId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (heroId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.heroId,
                        referencedTable: $$RedemptionsTableReferences
                            ._heroIdTable(db),
                        referencedColumn: $$RedemptionsTableReferences
                            ._heroIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RedemptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RedemptionsTable,
      RedemptionRow,
      $$RedemptionsTableFilterComposer,
      $$RedemptionsTableOrderingComposer,
      $$RedemptionsTableAnnotationComposer,
      $$RedemptionsTableCreateCompanionBuilder,
      $$RedemptionsTableUpdateCompanionBuilder,
      (RedemptionRow, $$RedemptionsTableReferences),
      RedemptionRow,
      PrefetchHooks Function({bool heroId})
    >;
typedef $$CompletionsTableCreateCompanionBuilder =
    CompletionsCompanion Function({
      required String id,
      required String habitId,
      required DateTime at,
      required int exp,
      required Frequency frequency,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CompletionsTableUpdateCompanionBuilder =
    CompletionsCompanion Function({
      Value<String> id,
      Value<String> habitId,
      Value<DateTime> at,
      Value<int> exp,
      Value<Frequency> frequency,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CompletionsTableReferences
    extends BaseReferences<_$AppDatabase, $CompletionsTable, CompletionRow> {
  $$CompletionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $HabitsTable _habitIdTable(_$AppDatabase db) =>
      db.habits.createAlias('completions__habit_id__habits__id');

  $$HabitsTableProcessedTableManager get habitId {
    final $_column = $_itemColumn<String>('habit_id')!;

    final manager = $$HabitsTableTableManager(
      $_db,
      $_db.habits,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_habitIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $CompletionsTable> {
  $$CompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get at =>
      $composableBuilder(
        column: $table.at,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get exp => $composableBuilder(
    column: $table.exp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Frequency, Frequency, String> get frequency =>
      $composableBuilder(
        column: $table.frequency,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$HabitsTableFilterComposer get habitId {
    final $$HabitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableFilterComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompletionsTable> {
  $$CompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get at => $composableBuilder(
    column: $table.at,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get exp => $composableBuilder(
    column: $table.exp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$HabitsTableOrderingComposer get habitId {
    final $$HabitsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableOrderingComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompletionsTable> {
  $$CompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get at =>
      $composableBuilder(column: $table.at, builder: (column) => column);

  GeneratedColumn<int> get exp =>
      $composableBuilder(column: $table.exp, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Frequency, String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$HabitsTableAnnotationComposer get habitId {
    final $$HabitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.habitId,
      referencedTable: $db.habits,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HabitsTableAnnotationComposer(
            $db: $db,
            $table: $db.habits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompletionsTable,
          CompletionRow,
          $$CompletionsTableFilterComposer,
          $$CompletionsTableOrderingComposer,
          $$CompletionsTableAnnotationComposer,
          $$CompletionsTableCreateCompanionBuilder,
          $$CompletionsTableUpdateCompanionBuilder,
          (CompletionRow, $$CompletionsTableReferences),
          CompletionRow,
          PrefetchHooks Function({bool habitId})
        > {
  $$CompletionsTableTableManager(_$AppDatabase db, $CompletionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> habitId = const Value.absent(),
                Value<DateTime> at = const Value.absent(),
                Value<int> exp = const Value.absent(),
                Value<Frequency> frequency = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CompletionsCompanion(
                id: id,
                habitId: habitId,
                at: at,
                exp: exp,
                frequency: frequency,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String habitId,
                required DateTime at,
                required int exp,
                required Frequency frequency,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CompletionsCompanion.insert(
                id: id,
                habitId: habitId,
                at: at,
                exp: exp,
                frequency: frequency,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CompletionsTable, CompletionRow>(table),
                  $$CompletionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({habitId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (habitId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.habitId,
                        referencedTable: $$CompletionsTableReferences
                            ._habitIdTable(db),
                        referencedColumn: $$CompletionsTableReferences
                            ._habitIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompletionsTable,
      CompletionRow,
      $$CompletionsTableFilterComposer,
      $$CompletionsTableOrderingComposer,
      $$CompletionsTableAnnotationComposer,
      $$CompletionsTableCreateCompanionBuilder,
      $$CompletionsTableUpdateCompanionBuilder,
      (CompletionRow, $$CompletionsTableReferences),
      CompletionRow,
      PrefetchHooks Function({bool habitId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HeroesTableTableManager get heroes =>
      $$HeroesTableTableManager(_db, _db.heroes);
  $$HabitsTableTableManager get habits =>
      $$HabitsTableTableManager(_db, _db.habits);
  $$RewardsTableTableManager get rewards =>
      $$RewardsTableTableManager(_db, _db.rewards);
  $$RedemptionsTableTableManager get redemptions =>
      $$RedemptionsTableTableManager(_db, _db.redemptions);
  $$CompletionsTableTableManager get completions =>
      $$CompletionsTableTableManager(_db, _db.completions);
}
