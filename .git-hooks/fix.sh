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

# выбираем, как запускать eslint (bun если есть, иначе npx)
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

echo "🔎 Начинаю проверку ${#FILES[@]} staged файлов на ошибки ESLint:"
printf ' - %s\n' "${FILES[@]}"

echo "🚀 Запускаю: ${ESLINT_CMD[*]} ..."
if ! "${ESLINT_CMD[@]}" "${FILES[@]}"; then
  echo "⚠️ ESLint завершился с ошибкой. Прервано."
  exit 1
fi

echo "✅ ESLint проверка пройдена, ошибок нет."
exit 0
