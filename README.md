# НСТ «Горняк»

Статический сайт публикуется на GitHub Pages. Вход пользователей, новости и документы хранятся в Supabase; права администратора дополнительно проверяются политиками базы данных.

## Настройка Supabase

1. Создайте проект в [Supabase](https://supabase.com/).
2. В SQL Editor выполните содержимое [`supabase/schema.sql`](./supabase/schema.sql).
3. Откройте Project Settings → API и скопируйте Project URL и публичный `anon` key (не `service_role`).
4. В `index.html` замените `YOUR_PROJECT_ID` в `window.SUPABASE_CONFIG.url` и `YOUR_SUPABASE_ANON_KEY` в `window.SUPABASE_CONFIG.anonKey`.
5. В Supabase Authentication → URL Configuration установите URL сайта как Site URL и добавьте адрес GitHub Pages в Redirect URLs.
6. Зарегистрируйте свой аккаунт на сайте и подтвердите адрес электронной почты, если включено подтверждение.
7. В Supabase SQL Editor назначьте администратора, указав почту зарегистрированного аккаунта:

   ```sql
   insert into public.site_admins (user_id)
   select id from auth.users where email = 'ваш-email@example.com'
   on conflict (user_id) do nothing;
   ```

   Выполняйте это только для доверенных администраторов. Новые регистрации по умолчанию не получают права редактирования.
8. Опубликуйте изменения `index.html` на GitHub Pages.

После настройки администратор сможет публиковать, редактировать и удалять новости и документы. Для документа указывается ссылка `http://` или `https://`; сам файл нужно предварительно разместить на доступном хранилище.

Публичный `anon` key предназначен для клиентского сайта. Не помещайте в HTML ключ `service_role`: он обходит политики доступа и предоставляет полный доступ к базе.
