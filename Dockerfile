FROM ydkn/cups:latest

# Copy your install script and filters into the image
COPY --chmod=777 install /install.sh
COPY --chmod=755 rastertolabelbeeprt /usr/lib/cups/filter/

# Run the install script with input "your"
RUN echo "y" | /install.sh

EXPOSE 631

CMD ["/usr/sbin/cupsd", "-f"]