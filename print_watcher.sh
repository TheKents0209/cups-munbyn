#!/bin/bash

WATCH_DIR="/print_queue"
DONE_DIR="/completed"
PRINTER_NAME="MunbynITPP941"

mkdir -p "$DONE_DIR"

echo "Watcher started, watching $WATCH_DIR"

inotifywait -m -e create --format "%f" "$WATCH_DIR" | while read FILE; do
    # Only process real, non-cropped PDFs
    if [[ "$FILE" == *.pdf && "$FILE" != cropped_*.pdf ]]; then
        FULL_PATH="$WATCH_DIR/$FILE"

        echo "Detected $FILE. Waiting for it to finish copying..."

        # Wait until file size is stable (not growing)
        PREV_SIZE=0
        while true; do
            sleep 0.5
            CUR_SIZE=$(stat -c%s "$FULL_PATH" 2>/dev/null || echo 0)
            if [[ "$CUR_SIZE" -eq "$PREV_SIZE" && "$CUR_SIZE" -gt 0 ]]; then
                break
            fi
            PREV_SIZE="$CUR_SIZE"
        done

        echo "Printing $FILE"
        CROPPED_FILE="cropped_$FILE"
	CROPPED_PATH="$WATCH_DIR/$CROPPED_FILE"

pdfcrop "$FULL_PATH" "$WATCH_DIR/$CROPPED_FILE" && \
for i in {1..10}; do
  if [[ -s "$WATCH_DIR/$CROPPED_FILE" ]]; then
    break
  fi
  echo "Waiting for $CROPPED_FILE to become available..."
  sleep 0.5
done && \
JOB_ID=$(lp -d "$PRINTER_NAME" -o fit-to-page "$WATCH_DIR/$CROPPED_FILE" | awk '{print $4}' | cut -d'-' -f2) && \
echo "Waiting for print job $JOB_ID to finish..." && \
while lpstat -W not-completed | grep -q "$JOB_ID"; do sleep 1; done && \
echo "Print job $JOB_ID completed." && \
mv "$WATCH_DIR/$CROPPED_FILE" "$DONE_DIR/$FILE" && \
rm "$FULL_PATH"

lp -d "$PRINTER_NAME" -o fit-to-page "$CROPPED_PATH"

    fi
done
