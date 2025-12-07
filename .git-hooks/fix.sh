#!/usr/bin/env bash
set -euo pipefail

# абсолютный путь к bun в домашней папке пользователя
BUN_PATH="$HOME/.bun/bin/bun"

# собираем staged файлы в массив совместимым способом (поддерживает пробелы)
FILES=()
while IFS= read -r -d '' file; do
  # фильтруем по расширениям
  case "$file" in
    *.ts|*.tsx|*.js|*.jsx|*.vue|*.mjs|*.csjs|*.mts|*.cts)
      FILES+=("$file")
      ;;
    *)
      ;;
  esac
done < <(git diff --cached --name-only --diff-filter=ACM -z)

if [ ${#FILES[@]} -eq 0 ]; then
  echo "✨ Нет staged файлов подходящих по расширениям. Нечего фиксить."
  exit 0
fi

# выбираем, как запускать eslint/prettier (bun если есть, иначе npx)
if [ -x "$BUN_PATH" ]; then
  echo "✅ Bun найден по пути: $BUN_PATH — используем Bun"
  ESLINT_CMD=("$BUN_PATH" "eslint")
elif command -v npx >/dev/null 2>&1; then
  echo "ℹ️ Bun не найден — используем npx"
  ESLINT_CMD=(npx eslint)
else
  echo "❌ Не найден bun ($BUN_PATH) и не найден npx. Установите bun или node/npm (npx)."
  exit 1
fi

echo "🛠 Автофикс для ${#FILES[@]} staged файлов:"
printf ' - %s\n' "${FILES[@]}"

# ESLint --fix
echo "🔎 Запускаю: ${ESLINT_CMD[*]} --fix ..."
if ! "${ESLINT_CMD[@]}" --fix "${FILES[@]}"; then
  echo "⚠️ ESLint завершился с ошибкой. Прервано."
  exit 1
fi

# добавляем исправленные файлы обратно в staged
echo "📥 Добавляю исправленные файлы обратно в staged..."
git add -- "${FILES[@]}"

echo "✅ Автофикс завершён. Готово к коммиту."
exit 0
