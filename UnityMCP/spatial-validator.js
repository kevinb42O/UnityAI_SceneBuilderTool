#!/usr/bin/env node

/**
 * Spatial Validation Utilities
 * Validates object placement to prevent overlaps and ensure proper positioning
 */

/**
 * Check if two objects overlap in 3D space
 * @param {object} obj1 - First object with position and scale
 * @param {object} obj2 - Second object with position and scale
 * @returns {boolean} True if objects overlap
 */
export function checkOverlap(obj1, obj2) {
  // Calculate bounding boxes
  const box1 = {
    minX: obj1.position.x - obj1.scale.x / 2,
    maxX: obj1.position.x + obj1.scale.x / 2,
    minY: obj1.position.y - obj1.scale.y / 2,
    maxY: obj1.position.y + obj1.scale.y / 2,
    minZ: obj1.position.z - obj1.scale.z / 2,
    maxZ: obj1.position.z + obj1.scale.z / 2,
  };

  const box2 = {
    minX: obj2.position.x - obj2.scale.x / 2,
    maxX: obj2.position.x + obj2.scale.x / 2,
    minY: obj2.position.y - obj2.scale.y / 2,
    maxY: obj2.position.y + obj2.scale.y / 2,
    minZ: obj2.position.z - obj2.scale.z / 2,
    maxZ: obj2.position.z + obj2.scale.z / 2,
  };

  // Check for overlap on all axes
  const overlapX = box1.minX <= box2.maxX && box1.maxX >= box2.minX;
  const overlapY = box1.minY <= box2.maxY && box1.maxY >= box2.minY;
  const overlapZ = box1.minZ <= box2.maxZ && box1.maxZ >= box2.minZ;

  return overlapX && overlapY && overlapZ;
}

/**
 * Validate that object Y position is correct for ground placement
 * @param {object} obj - Object with position and scale
 * @returns {object} Validation result with corrected Y if needed
 */
export function validateGroundPlacement(obj) {
  const expectedY = obj.scale.y / 2;
  const currentY = obj.position.y;
  const tolerance = 0.01;

  if (Math.abs(currentY - expectedY) > tolerance) {
    return {
      valid: false,
      expectedY: expectedY,
      currentY: currentY,
      correction: {
        ...obj,
        position: {
          ...obj.position,
          y: expectedY
        }
      }
    };
  }

  return { valid: true };
}

/**
 * Calculate proper stacking position (object on top of another)
 * @param {object} bottomObj - Bottom object with position and scale
 * @param {object} topObj - Top object with scale
 * @returns {number} Correct Y position for top object
 */
export function calculateStackPosition(bottomObj, topObj) {
  const bottomTop = bottomObj.position.y + bottomObj.scale.y / 2;
  const topHeight = topObj.scale.y / 2;
  return bottomTop + topHeight;
}

/**
 * Calculate proper adjacent position (objects side by side)
 * @param {object} existingObj - Existing object
 * @param {object} newObj - New object to place
 * @param {string} direction - 'left', 'right', 'front', 'back'
 * @param {number} gap - Minimum gap between objects (default 0.5)
 * @returns {object} Position for new object
 */
export function calculateAdjacentPosition(existingObj, newObj, direction, gap = 0.5) {
  const pos = { ...existingObj.position };

  switch (direction) {
    case 'right':
      pos.x = existingObj.position.x + (existingObj.scale.x / 2) + (newObj.scale.x / 2) + gap;
      break;
    case 'left':
      pos.x = existingObj.position.x - (existingObj.scale.x / 2) - (newObj.scale.x / 2) - gap;
      break;
    case 'front':
      pos.z = existingObj.position.z + (existingObj.scale.z / 2) + (newObj.scale.z / 2) + gap;
      break;
    case 'back':
      pos.z = existingObj.position.z - (existingObj.scale.z / 2) - (newObj.scale.z / 2) - gap;
      break;
  }

  // Keep same Y if both on ground, otherwise calculate
  if (Math.abs(existingObj.position.y - existingObj.scale.y / 2) < 0.01) {
    pos.y = newObj.scale.y / 2;
  }

  return pos;
}

/**
 * Validate entire scene for overlaps and positioning issues
 * @param {array} objects - Array of objects with position and scale
 * @returns {object} Validation report
 */
export function validateScene(objects) {
  const issues = [];
  const warnings = [];

  // Check each object
  objects.forEach((obj, index) => {
    // Validate ground placement
    const groundCheck = validateGroundPlacement(obj);
    if (!groundCheck.valid) {
      warnings.push({
        type: 'incorrect_ground_placement',
        object: obj.name,
        message: `Object Y position (${groundCheck.currentY.toFixed(2)}) should be ${groundCheck.expectedY.toFixed(2)} for ground placement`,
        correction: groundCheck.correction
      });
    }

    // Check for overlaps with other objects
    for (let i = index + 1; i < objects.length; i++) {
      const other = objects[i];
      if (checkOverlap(obj, other)) {
        issues.push({
          type: 'overlap',
          objects: [obj.name, other.name],
          message: `Objects "${obj.name}" and "${other.name}" overlap in space`
        });
      }
    }

    // Check for extremely small or large scales
    const minScale = 0.01;
    const maxScale = 100;
    if (obj.scale.x < minScale || obj.scale.y < minScale || obj.scale.z < minScale) {
      warnings.push({
        type: 'too_small',
        object: obj.name,
        message: `Object scale is very small (x:${obj.scale.x}, y:${obj.scale.y}, z:${obj.scale.z}), might be invisible`
      });
    }
    if (obj.scale.x > maxScale || obj.scale.y > maxScale || obj.scale.z > maxScale) {
      warnings.push({
        type: 'too_large',
        object: obj.name,
        message: `Object scale is very large (x:${obj.scale.x}, y:${obj.scale.y}, z:${obj.scale.z}), might be impractical`
      });
    }
  });

  return {
    valid: issues.length === 0,
    issueCount: issues.length,
    warningCount: warnings.length,
    issues: issues,
    warnings: warnings
  };
}

/**
 * Auto-fix common positioning issues
 * @param {array} objects - Array of objects
 * @returns {array} Fixed objects
 */
export function autoFixPositioning(objects) {
  const fixed = objects.map(obj => {
    // Fix ground placement
    const groundCheck = validateGroundPlacement(obj);
    if (!groundCheck.valid) {
      return groundCheck.correction;
    }
    return obj;
  });

  // Try to resolve overlaps by adjusting positions
  for (let i = 0; i < fixed.length; i++) {
    for (let j = i + 1; j < fixed.length; j++) {
      if (checkOverlap(fixed[i], fixed[j])) {
        // Move second object to the right to avoid overlap
        const gap = 0.5;
        fixed[j].position.x = fixed[i].position.x + 
          (fixed[i].scale.x / 2) + (fixed[j].scale.x / 2) + gap;
      }
    }
  }

  return fixed;
}

/**
 * Generate spacing recommendations for array patterns
 * @param {object} templateObj - Template object with scale
 * @param {string} arrayType - 'linear', 'circular', 'grid'
 * @returns {number} Recommended spacing
 */
export function recommendSpacing(templateObj, arrayType) {
  const maxDimension = Math.max(templateObj.scale.x, templateObj.scale.z);
  const minGap = 0.5;

  switch (arrayType) {
    case 'linear':
      return maxDimension + minGap;
    case 'circular':
      // For circular, spacing is radius, so allow objects to fit comfortably
      return maxDimension * 1.5;
    case 'grid':
      return maxDimension + minGap;
    default:
      return maxDimension + minGap;
  }
}
