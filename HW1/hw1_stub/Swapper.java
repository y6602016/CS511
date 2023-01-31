public class Swapper implements Runnable {
    private int offset;
    private Interval interval;
    private String content;
    private char[] buffer;

    public Swapper(Interval interval, String content, char[] buffer, int offset) {
        this.offset = offset;
        this.interval = interval;
        this.content = content;
        this.buffer = buffer;
    }

    @Override
    public void run() {
        // TODO: Implement me!
        int chunkSize = interval.getY() - interval.getX() + 1;
        int j = 0;
        for (int i = offset; i < offset + chunkSize; i++) {
            buffer[i] = content.charAt(interval.getX() + j);
            j++;
        }
    }
}