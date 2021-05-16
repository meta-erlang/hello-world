-record(hhs_user, {
    username,
    password_hash,
    email,
    validation_token = "",
    roles = [],
    remember_me_tokens = []
}).

% four weeks
-define(REMEMBER_ME_TTL, 40320).
