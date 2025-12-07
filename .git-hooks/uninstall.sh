#!/bin/bash
set -e

echo "🧹 Отключение Git hooks..."

HOOKS_DIR=".git/hooks"
CUSTOM_DIR=".git-hooks"  # папка с твоими кастомными хуками

HOOKS=("pre-commit" "pre-push")

for HOOK in "${HOOKS[@]}"; do
    TARGET="$HOOKS_DIR/$HOOK"

    if [ -L "$TARGET" ]; then
        LINK_TARGET=$(readlink "$TARGET")
        # Проверяем, что симлинк указывает на кастомную папку
        if [[ "$LINK_TARGET" == *"$CUSTOM_DIR"* ]]; then
            rm -f "$TARGET"
            echo "✅ Hook $HOOK безопасно отключён"
        else
            echo "⚠️ Hook $HOOK не удалён: это не наш симлинк ($LINK_TARGET)"
        fi
    elif [ -f "$TARGET" ]; then
        echo "⚠️ Hook $HOOK не является симлинком, оставляем его в покое"
    else
        echo "ℹ️ Hook $HOOK не найден"
    fi
done

echo "👌 Git hooks обработаны!"
