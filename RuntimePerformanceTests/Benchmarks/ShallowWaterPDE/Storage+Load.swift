import Foundation
import PNG

extension Array2DStorage where Element == Float {
    @inlinable
    static func loadTarget(target: URL, resolution: Int) -> Self {
        let targetImage = try! PNG.Image.decompress(path: target.path)! // swiftlint:disable:this force_try force_unwrapping
        let pixels = targetImage.unpack(as: PNG.RGBA<UInt8>.self).map { Float($0.r) }
        let storage = Array2DStorage(width: targetImage.size.x, height: targetImage.size.y, values: pixels)
        let target = storage.bilinearResizeTo(width: resolution, height: resolution).map { ($0 - Float(UInt8.max) / 2) / Float(UInt8.max) }
        return target
    }

    @inlinable
    func bilinearResizeTo(width: Int, height: Int) -> Self {
        var new = Self(repeating: 0, width: width, height: height)

        let scaleWidth = Float(self.width) / Float(new.width)
        let scaleHeight = Float(self.height) / Float(new.height)

        for j in 0 ..< new.height {
            for i in 0 ..< new.width {
                let x = Float(i) * scaleWidth
                let y = Float(j) * scaleHeight

                let xFloor: Float = floor(x)
                let xCeil: Float = min(Float(self.width - 1), ceil(x))

                let yFloor: Float = floor(y)
                let yCeil: Float = min(Float(self.height - 1), ceil(y))
                
                let ix = Int(x)
                let iy = Int(y)
                let ixFloor = Int(xFloor)
                let iyFloor = Int(yFloor)
                let ixCeil = Int(xCeil)
                let iyCeil = Int(yCeil)

                let q: Float
                if xCeil == xFloor && yCeil == yFloor {
                    q = self[ix, iy]
                }
                else if xCeil == xFloor {
                    let q1 = self[ix, iyFloor]
                    let q2 = self[ix, iyCeil]
                    q = q1 * (yCeil - y) + q2 * (y - yFloor)
                }
                else if yCeil == yFloor {
                    let q1 = self[ixFloor, iy]
                    let q2 = self[ixCeil, iy]
                    q = (q1 * (xCeil - x)) + (q2 * (x - xFloor))
                }
                else {
                    let v1 = self[ixFloor, iyFloor]
                    let v2 = self[ixCeil, iyFloor]
                    let v3 = self[ixFloor, iyCeil]
                    let v4 = self[ixCeil, iyCeil]

                    let q1 = v1 * (xCeil - x) + v2 * (x - xFloor)
                    let q2 = v3 * (xCeil - x) + v4 * (x - xFloor)
                    q = q1 * (yCeil - y) + q2 * (y - yFloor)
                }
                new[i, j] = q
            }
        }

        return new
    }
}

