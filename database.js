// Слой данных (RAM / Database) для портала НСТ «Горняк»

// Слой данных (RAM / Database) для портала НСТ «Горняк»

const DB_KEYS = {
    news: 'gornyak_news_db',
    docs: 'gornyak_docs_db',
    chat: 'gornyak_real_chat',
    profiles: 'gornyak_profiles',
    user: 'gornyak_user',
    cards: 'gornyak_cards',
    settings: 'gornyak_settings',
    notifs: 'gornyak_notifications',
    about: 'gornyak_about'
};

const Database = {
    get(key, defaultValue) {
        try {
            const val = JSON.parse(localStorage.getItem(DB_KEYS[key] || key));
            return val == null ? defaultValue : val;
        } catch (e) {
            return defaultValue;
        }
    },

    set(key, value) {
        try {
            localStorage.setItem(DB_KEYS[key] || key, JSON.stringify(value));
            return true;
        } catch (e) {
            console.error('Ошибка сохранения данных:', e);
            return false;
        }
    },

    remove(key) {
        localStorage.removeItem(DB_KEYS[key] || key);
    },

    getCurrentUser() {
        return this.get('user', null);
    },

    getMyNick() {
        const u = this.getCurrentUser();
        return u ? (u.name || u.email.split('@')[0]) : 'Гость';
    },

    getMyUid() {
        const u = this.getCurrentUser();
        return u ? u.email : 'guest';
    },

    // Проверка, является ли текущий пользователь владельцем записи
    isOwner(itemAuthorUid) {
        const currentId = this.getMyUid();
        // Если запись создана гостем или без UID, разрешаем гостю (или совпадению по нику)
        if (!itemAuthorUid || itemAuthorUid === 'guest') {
            return currentId === 'guest';
        }
        return itemAuthorUid === currentId;
    }
};
