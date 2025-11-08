using UnityEngine;

public struct SoundHandle { public static SoundHandle Invalid => new SoundHandle(); public bool IsValid => false; public bool IsPlaying => false; public void Stop() { } }
public static class GameSounds { public static void PlayCrouchSlamImpact(Vector3 position, float intensity = 1f) { } public static void PlayFallDamage(Vector3 position, float volume = 1f) { } public static SoundHandle PlayPlayerJump(Vector3 position, float volume = 1f) { return SoundHandle.Invalid; } public static SoundHandle PlayPlayerLand(Vector3 position, float volume = 1f) { return SoundHandle.Invalid; } public static SoundHandle PlayPlayerDoubleJump(Vector3 position, float volume = 1f) { return SoundHandle.Invalid; } public static SoundHandle PlayPlayerWallJump(Vector3 position, float volume = 1f) { return SoundHandle.Invalid; } public static SoundHandle PlayTrickStartSound(Vector3 position, float volume = 1f) { return SoundHandle.Invalid; } }
public class SoundEvent { public AudioClip clip; public int Length => 1; public SoundHandle Play2D(float volume) { return SoundHandle.Invalid; } public void Stop() { } }
public class SoundEventCollection { public SoundEvent slideSound = new SoundEvent(); public AudioClip[] fallDamage = new AudioClip[0]; public SoundEvent tacticalDiveSound = new SoundEvent(); }
public static class SoundEventsManager { public enum SoundEventType { SlideStart, SlideLoop, SlideEnd } public static SoundEventCollection Events = new SoundEventCollection(); public static void StopEvent(SoundEventType eventType, SoundHandle handle) { } public static SoundHandle PlayEvent(SoundEventType eventType, Vector3 position) { return SoundHandle.Invalid; } }
public class PlayerEnergySystem : MonoBehaviour { public bool IsSprinting => false; public bool IsCurrentlySprinting => false; public bool CanSprint() => true; public void ConsumeSprint(float amount) { } public static event System.Action OnSprintInterrupted = delegate { }; }
public class PlayerHealth : MonoBehaviour { public bool IsBleedingOut => false; public bool isBleedingOut => false; }
public class ElevatorController : MonoBehaviour { public Vector3 GetVelocity() => Vector3.zero; public bool IsPlayerInElevator(CharacterController controller) => false; }
public class CelestialPlatform : MonoBehaviour { public void RegisterPassenger(AAAMovementController passenger) { } public void UnregisterPassenger(AAAMovementController passenger) { } public Vector3 GetCurrentVelocity() => Vector3.zero; public Vector3 GetMovementDelta() => Vector3.zero; }
public class CelestialDriftController : MonoBehaviour { }
public class PlayerMovementManager : MonoBehaviour { }
public class DeathCameraController : MonoBehaviour { }
public class AAAMovementIntegrator : MonoBehaviour { }
public class AAAMovementAudioManager : MonoBehaviour { public void PlayJumpSound() { } }
public class PlayerRaycastManager : MonoBehaviour { public bool Raycast(Vector3 origin, Vector3 direction, out RaycastHit hit, float distance, LayerMask mask) { return Physics.Raycast(origin, direction, out hit, distance, mask); } public bool HasValidGroundHit => false; public RaycastHit GroundHit => new RaycastHit(); public bool IsGrounded() => false; }
public class GameManager : MonoBehaviour { private static GameManager _instance; public static GameManager Instance { get { if (_instance == null) _instance = FindObjectOfType<GameManager>(); return _instance; } } public PlayerAnimationStateManager GetPlayerAnimationStateManager() => FindObjectOfType<PlayerAnimationStateManager>(); public LayeredHandAnimationController GetLayeredHandAnimationController() => FindObjectOfType<LayeredHandAnimationController>(); public PlayerEnergySystem GetEnergySystem() => FindObjectOfType<PlayerEnergySystem>(); public PlayerMovementManager GetPlayerMovementManager() => FindObjectOfType<PlayerMovementManager>(); }
public class LayeredHandAnimationController : MonoBehaviour { public void TriggerLandAnimation(float impactSeverity = 0f) { } public void TriggerSlideAnimation() { } public void TriggerDiveAnimation() { } }
public enum PlayerAnimationState { Idle, Walking, Running, Jumping, Falling, Landing, Crouching, Sliding, WallSliding, Sprint, Slide, Land, Jump }
public class PlayerAnimationStateManager : MonoBehaviour { public enum PlayerAnimationState { Idle, Walking, Running, Jumping, Falling, Landing, Crouching, Sliding, WallSliding, Sprint, Slide, Land, Jump } public void TriggerLandAnimation(float impactSeverity = 0f) { } public void SetMovementState(PlayerAnimationState state) { } public void SetMovementState(int state) { } }
public class TimeDilationManager : MonoBehaviour { private static TimeDilationManager _instance; public static TimeDilationManager Instance { get { if (_instance == null) _instance = FindObjectOfType<TimeDilationManager>(); return _instance; } } public void ForceNormalTime() { } public bool IsTimeDilationActive() => false; public float GetCurrentTimeScale() => 1f; public void SetTrickSystemDilation(bool enabled) { } public void SetTrickSystemDilation(bool enabled, float scale, float transitionSpeed) { } }
public struct ImpactData { public float compressionAmount; public float severityNormalized; public string severity; public float fallDistance; public float traumaIntensity; public bool wasInTrick; }
public static class ImpactEventBroadcaster { public static event System.Action<ImpactData> OnImpact; }
public class WallJumpXPSimple : MonoBehaviour { private static WallJumpXPSimple _instance; public static WallJumpXPSimple Instance { get { if (_instance == null) _instance = FindObjectOfType<WallJumpXPSimple>(); return _instance; } } public void AwardWallJumpXP(Vector3 position) { } public void AwardPerfectWallJump(Vector3 position) { } public void ResetChain() { } public void OnWallJumpPerformed(Vector3 position) { } }
public class AerialTrickXPSystem : MonoBehaviour { private static AerialTrickXPSystem _instance; public static AerialTrickXPSystem Instance { get { if (_instance == null) _instance = FindObjectOfType<AerialTrickXPSystem>(); return _instance; } } public void AwardFlipXP(string trickName, Vector3 position) { } public void AwardSpinXP(string trickName, Vector3 position) { } public void OnTrickLanded(float airtime, Vector3 rotations, Vector3 position, bool isClean) { } }
public class ComboMultiplierSystem : MonoBehaviour { private static ComboMultiplierSystem _instance; public static ComboMultiplierSystem Instance { get { if (_instance == null) _instance = FindObjectOfType<ComboMultiplierSystem>(); return _instance; } } public void ResetCombo() { } public void IncrementCombo() { } public void AddWallJump(bool isAirborne) { } public void AddTrick(float multiplier, bool isAirborne) { } }
public class WallJumpImpactVFX : MonoBehaviour { private static WallJumpImpactVFX _instance; public static WallJumpImpactVFX Instance { get { if (_instance == null) _instance = FindObjectOfType<WallJumpImpactVFX>(); return _instance; } } public void SpawnImpact(Vector3 position, Vector3 normal, float intensity) { } public void SpawnWallCrack(Vector3 position, Vector3 normal) { } public void SpawnDustBurst(Vector3 position, Vector3 normal, float intensity) { } public void SpawnEnergyRing(Vector3 position, Vector3 normal) { } public void SpawnPerfectWallJumpVFX(Vector3 position, Vector3 normal) { } public void SetBaseDuration(float duration) { } public void SetEffectScale(float scale) { } public void SetSpeedThresholds(float min, float max) { } public void SetIntensityRange(float min, float max) { } public void TriggerImpactEffect(Vector3 position, Vector3 normal, float speed, Collider collider) { } }
public class MomentumVisualization : MonoBehaviour { private static MomentumVisualization _instance; public static MomentumVisualization Instance { get { if (_instance == null) _instance = FindObjectOfType<MomentumVisualization>(); return _instance; } } public void ShowMomentumGain(Vector3 position, Vector3 velocity) { } public void ShowMomentumLoss(Vector3 position, Vector3 velocity) { } public void BreakChain() { } public void OnSpeedGain(float speedBefore, float speedAfter, Vector3 position) { } }
public class CognitiveFeedManager : MonoBehaviour { private static CognitiveFeedManager _instance; public static CognitiveFeedManager Instance { get { if (_instance == null) _instance = FindObjectOfType<CognitiveFeedManager>(); return _instance; } } public void ShowMessage(string message, float duration = 2f) { } public void QueueMessage(string message, float duration = 2f) { } }
public static class Controls 
{ 
    private static InputConfig _config;
    
    public static InputConfig Config
    {
        get
        {
            if (_config == null)
            {
                // Try to load from Resources folder first
                _config = Resources.Load<InputConfig>("InputConfig");
                
                // If not found, create a default runtime config
                if (_config == null)
                {
                    _config = InputConfig.CreateDefault();
                    Debug.LogWarning("[AAA Movement] No InputConfig found in Resources folder. Using default controls. Create one via: Assets > Create > AAA Movement > Input Configuration");
                }
            }
            return _config;
        }
        set => _config = value;
    }
    
    public static InputButton Crouch => new InputButton(() => Config.GetCrouchDown(), () => Config.GetCrouchHeld(), () => false, Config.crouchKey);
    public static InputButton Dive => new InputButton(() => Config.GetDiveDown(), () => Input.GetKey(Config.diveKey), () => Input.GetKeyUp(Config.diveKey), Config.diveKey);
    public static InputButton Jump => new InputButton(() => Config.GetJumpDown(), () => Config.GetJumpHeld(), () => Config.GetJumpUp(), Config.jumpKey);
    public static InputButton Sprint => new InputButton(() => false, () => Config.GetSprintHeld(), () => false, Config.sprintKey);
    public static InputButton UpThrustJump => new InputButton(() => Config.GetJumpDown(), () => Config.GetJumpHeld(), () => Config.GetJumpUp(), Config.jumpKey);
    public static InputButton Boost => new InputButton(() => false, () => Config.GetSprintHeld(), () => false, Config.sprintKey);
    public static float HorizontalRaw => Config.GetHorizontalRaw();
    public static float VerticalRaw => Config.GetVerticalRaw();
}

public class InputButton 
{ 
    private System.Func<bool> getPressedThisFrame;
    private System.Func<bool> getIsPressed;
    private System.Func<bool> getReleasedThisFrame;
    private KeyCode keyCode;
    
    public InputButton(System.Func<bool> pressedThisFrame, System.Func<bool> isPressed, System.Func<bool> releasedThisFrame, KeyCode key) 
    { 
        getPressedThisFrame = pressedThisFrame;
        getIsPressed = isPressed;
        getReleasedThisFrame = releasedThisFrame;
        keyCode = key;
    }
    
    public bool WasPressedThisFrame() => getPressedThisFrame();
    public bool IsPressed() => getIsPressed();
    public bool WasReleasedThisFrame() => getReleasedThisFrame();
    public static implicit operator KeyCode(InputButton button) => button.keyCode;
}
namespace GeminiGauntlet.Audio { public static class GameSounds { public static void PlaySlideLoopAudio(Vector3 position, float volume = 1f) { } public static void PlayTrickStartSound(Vector3 position, float volume = 1f) { } } public static class SoundEvents { public static void PlayRandomSound3D(AudioClip[] clips, Vector3 position, float volume = 1f) { } } }
