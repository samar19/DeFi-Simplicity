// copied from https://github.com/pedrouid/blockies-ts

export const DEFAULT_SIZE = 8;
export const DEFAULT_SCALE = 4;

// The random number is a js implementation of the Xorshift PRNG
export const randArr = new Array(4); // Xorshift: [x, y, z, w] 32 bit values

export function seedRandomness(seed: string) {
  let i: number;
  for (i = 0; i < randArr.length; i++) {
    randArr[i] = 0;
  }
  for (i = 0; i < seed.length; i++) {
    randArr[i % 4] =
      (randArr[i % 4] << 5) - randArr[i % 4] + seed.charCodeAt(i);
  }
}

export function random() {
  // based on Java's String.hashCode(), expanded to 4 32bit values
  let t = randArr[0] ^ (randArr[0] << 11);

  randArr[0] = randArr[1];
  randArr[1] = randArr[2];
  randArr[2] = randArr[3];
  randArr[3] = randArr[3] ^ (randArr[3] >> 19) ^ t ^ (t >> 8);

  return (randArr[3] >>> 0) / ((1 << 31) >>> 0);
}

export interface BlockiesOptions {
  seed: string;
  size: number;
  scale: number;
  color: string;
  bgcolor: string;
  spotcolor: string;
}
export function createColor() {
  //saturation is the whole color spectrum
  let h = Math.floor(random() * 360);
  //saturation goes from 40 to 100, it avoids greyish colors
  let s = random() * 60 + 40 + "%";
  //lightness can be anything from 0 to 100, but probabilities are a bell curve around 50%
  let l = (random() + random() + random() + random()) * 25 + "%";

  let color = "hsl(" + h + "," + s + "," + l + ")";
  return color;
}

export function createImageData(size: number) {
  let width = size; // Only support square icons for now
  let height = size;

  let dataWidth = Math.ceil(width / 2);
  let mirrorWidth = width - dataWidth;

  let data: number[] = [];
  for (let y = 0; y < height; y++) {
    let row: number[] = [];
    for (let x = 0; x < dataWidth; x++) {
      // this makes foreground and background color to have a 43% (1/2.3) probability
      // spot color has 13% chance
      row[x] = Math.floor(random() * 2.3);
    }
    let r = row.slice(0, mirrorWidth);
    r.reverse();
    row = row.concat(r);

    for (let i = 0; i < row.length; i++) {
      data.push(row[i]);
    }
  }

  return data;
}

export function parseOptions(opts: Partial<BlockiesOptions>): BlockiesOptions {
  const seed =
    opts.seed || Math.floor(Math.random() * Math.pow(10, 16)).toString(16);

  seedRandomness(seed);

  return {
    seed,
    size: opts.size || DEFAULT_SIZE,
    scale: opts.scale || DEFAULT_SCALE,
    color: opts.color || createColor(),
    bgcolor: opts.bgcolor || createColor(),
    spotcolor: opts.spotcolor || createColor(),
  };
}

export function render(
  providedOpts: Partial<BlockiesOptions>,
  canvas: HTMLCanvasElement
) {
  const opts = parseOptions(providedOpts || {});
  let imageData = createImageData(opts.size);
  let width = Math.sqrt(imageData.length);

  canvas.width = canvas.height = opts.size * opts.scale;

  let context = canvas.getContext("2d");

  if (context) {
    // @ts-ignore
    context.fillStyle = opts.bgcolor;
    context.fillRect(0, 0, canvas.width, canvas.height);
    // @ts-ignore
    context.fillStyle = opts.color;

    for (let i = 0; i < imageData.length; i++) {
      // if data is 0, leave the background
      if (imageData[i]) {
        let row = Math.floor(i / width);
        let column = i % width;

        // if data is 2, choose spot color, if 1 choose foreground
        // @ts-ignore
        context.fillStyle = imageData[i] === 1 ? opts.color : opts.spotcolor;

        context.fillRect(
          column * opts.scale,
          row * opts.scale,
          opts.scale,
          opts.scale
        );
      }
    }
  }

  return canvas;
}

export function create(opts: Partial<BlockiesOptions>) {
  let canvas = document.createElement("canvas");
  render(opts, canvas);
  return canvas;
}
